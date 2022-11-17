class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: %i[ show edit update destroy download ]
  include Prawn::View


  # GET /expenses or /expenses.json
  def index
    # byebug
    # @q = Country.ransack(params[:q])
    # @countries = @q.result.includes(:currency)
    #                  .order(id: :asc).page(params[:page])

    @q = Expense.where(user_id: current_user.id).ransack(params[:q])
    @expenses = @q.result.order(id: :asc)
    @sum = @q.result.pluck(:amount).sum
  end

  # GET /expenses/1 or /expenses/1.json
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

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses or /expenses.json
  def create
    @expense = Expense.new(expense_params)
    @expense.user_id = current_user.id

    respond_to do |format|
      # byebug
      if @expense.save
        format.html { redirect_to expense_url(@expense), notice: "Expense was successfully created." }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to expense_url(@expense), notice: "Expense was successfully updated." }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense.destroy

    respond_to do |format|
      format.html { redirect_to expenses_url, notice: "Expense was successfully destroyed." }
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

    pdf.text "Category: #{@expense.category.name}"
    pdf.text "Amount: #{@expense.amount}"
    pdf.text "Description: #{@expense.description}"
    pdf.text "Avatar: "
    avatar_image = StringIO.open(@expense.avatar.download)
    pdf.image avatar_image, fit: [200, 200]
    pdf.text "Images: "
    count = @expense.images.count
    count.times do |i|
      image = StringIO.open(@expense.images[i].download)
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
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def expense_params
      params.require(:expense).permit(:user_id, :category_id, :amount, :description, :avatar, images: [])
    end
end
