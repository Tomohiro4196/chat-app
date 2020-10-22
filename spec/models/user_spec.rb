require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    before do
      @user = FactoryBot.build(:user)
    end

    it  "name、email、password、password_confirmationが存在すれば登録できる" do
      expect(@user).to be_valid
    end 

    it "passwordが6文字以上であれば登録できること" do
      @user.password = "000000"
      @user.password_confirmation = @user.password
      expect(@user).to be_valid
    end

    it "nameが空では登録できない" do
      @user.name = ""
      @user.valid?
      expect(@user.errors.full_messages).to include("Name can't be blank")
    
    end

    it "emailが空では登録できない" do
      @user.email = ""
      @user.valid?
      expect(@user.errors.full_messages).to include("Email can't be blank")
    
    end

    it "passwordが空では登録できない" do
      @user.password = ""
      @user.valid?
      expect(@user.errors.full_messages).to include("Password can't be blank")
    
    end

    it "passwordが5文字以下であれば登録できないこと" do
      @user.password = "00000"
      @user.password_confirmation = @user.password
      @user.valid?
      expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
    end

    it "passwordとpassword_confirmationが不一致では登録できないこと" do
      @user.password_confirmation = ""
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it "重複したemailが存在する場合登録できないこと" do
      @user.save
      #buildしたFactoryBotのFakerをsaveで保存する
      user2 = FactoryBot.build(:user)
      #もう１人のレコードを作る
      user2.email = @user.email
      #メールアドレスを重複させる
      user2.valid?
      expect(user2.errors.full_messages).to include("Email has already been taken")
      #新しく作ったUser2が保存できないことを確認する(1つ目 = @userは既にDBに保存済み)
    end

  end
end
