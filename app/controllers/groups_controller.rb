class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: %i[ show edit update destroy download ]
  include Prawn::View


  # GET /groups or /groups.json
  def index
    @q = group.where(user_id: current_user.id).ransack(params[:q])
    @groups = @q.result.order(id: :asc)
    @sum = @q.result.pluck(:amount).sum
  end

  # GET /groups/1 or /groups/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = PdfGenerator.new
        send_data pdf.render,
          filename: "export.pdf",
          type: 'application/pdf',
          disposition: 'inline'
      end
    end

  end

  # GET /groups/new
  def new
    @group = group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups or /groups.json
  def create
    @group = group.new(group_params)
    @group.user_id = current_user.id

    respond_to do |format|
      # byebug
      if @group.save
        format.html { redirect_to group_url(@group), notice: "group was successfully created." }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to group_url(@group), notice: "group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url, notice: "group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def download
    pdf = Prawn::Document.new

    file = Rails.root.join('app/assets/fonts/RobotoMono-Regular.ttf').to_s
    file_bold = Rails.root.join('app/assets/fonts/RobotoMono-Bold.ttf').to_s
    pdf.font_families['RobotoMono'] = {
      normal: { file: file },
      bold: { file: file_bold }
    }

    move_down_size = 16

    pdf.font 'RobotoMono'

    pdf.create_stamp('stamp') do
    pdf.fill_color 'b0eeff'
    pdf.text_box I18n.t('receipt.paid'),
                size: 100,
                width: 200,
                height: (200 / 2),
                align: :center,
                valign: :center,
                at: [0, 200]
    end
    pdf.stamp('stamp')

    pdf.text "Category: #{@group.category.name}"
    pdf.text "Amount: #{@group.amount}"
    pdf.text "Description: #{@group.description}"
    pdf.text "Avatar: "
    avatar_image = StringIO.open(@group.avatar.download)
    pdf.image avatar_image, fit: [200, 200]
    pdf.text "Images: "
    count = @group.images.count
    count.times do |i|
      image = StringIO.open(@group.images[i].download)
      pdf.image image, fit: [200, 200]
    end

    send_data(pdf.render, filename: 'hello.pdf', type: 'application/pdf')
  end

  def preview
    pdf = Prawn::Document.new

    pdf.image('app/assets/images/0.jpg', :position => :right, :vposition => :center, width: 200)
    pdf.image('app/assets/images/1.jpeg', width: 200)
    # :position => :right, :vposition => :center, :width => 270
    # pdf.text 'It only shows up in the preview route'
    # pdf.start_new_page
    # pdf.text 'This is a new page'
    send_data(pdf.render, filename: 'preview.pdf', type: 'application/pdf', disposition: 'inline')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = group.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:user_id, :category_id, :amount, :description, :avatar, images: [])
    end
end
