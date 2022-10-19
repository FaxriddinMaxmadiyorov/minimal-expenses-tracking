require 'rails_helper'

RSpec.describe User, type: :model do

  context 'validations' do
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_confirmation_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive.allow_blank }
  end

  let(:valid_attr) { attributes_for(:user) }
  let(:user) { User.new(valid_attr) }


  context 'user email validation' do
    it 'should not allow incorrect emails #1' do
      user.email = 'brown'
      expect(user).to_not be_valid
    end
    it 'should not allow incorrect emails #2' do
      user.email = 'brown@mail'
      expect(user).to_not be_valid
    end
    it 'should not allow incorrect emails #3' do
      user.email = 'brown@@mail.ru'
      expect(user).to_not be_valid
    end
    it 'should not allow incorrect emails #4' do
      user.email = '2brown@ma#il.ru'
      expect(user).to_not be_valid
    end
    it 'should allow correct emails #1' do
      user.email = 'brown@mail.ru'
      expect(user).to be_valid
    end
    it 'should allow correct emails #2' do
      user.email = '2brown@mail.ru'
      expect(user).to be_valid
    end
    it 'should allow correct emails #3' do
      user.email = 'brown@2mail.global'
      expect(user).to be_valid
    end
    it 'should allow correct emails #4' do
      user.email = 'brown@2mail.cc'
      expect(user).to be_valid
    end
  end

  context 'user password validation' do
    ### Incorrect passwords ###
    it 'should not allow incorrect passwords #1' do
      user.password = '12345'
      expect(user).to_not be_valid
    end
    it 'should not allow incorrect passwords #2' do
      user.password = '1'
      expect(user).to_not be_valid
    end
    it 'should not allow incorrect passwords #3' do
      user.password = 'asd'
      expect(user).to_not be_valid
    end
    ### Correct passwords ###
    it 'should allow correct passwords #1' do
      user.password = '123456'
      expect(user).to be_valid
    end
    it 'should allow correct passwords #2' do
      user.password = 'QWeasdzxc'
      expect(user).to be_valid
    end
    it 'should allow correct passwords #3' do
      user.password = '######.#>#>#>#>#'
      expect(user).to be_valid
    end
  end
end
