require 'rails_helper'

RSpec.describe "ユーザーログイン機能", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  it 'ログインしていない状態でトップページにアクセスした場合、サインインページに移動する' do
    # トップページに遷移する
      visit root_path
    # ログインしていない場合、サインインページに遷移していることを確認する
      expect(current_path).to eq new_user_session_path
  end

  it 'ログインに成功し、トップページに遷移する' do
    # 予め、ユーザーをDBに保存する
      
    # サインインページへ移動する
      visit root_path
    # ログインしていない場合、サインインページに遷移していることを確認する
      expect(current_path).to eq new_user_session_path
    # すでに保存されているユーザーのemailとpasswordを入力する
      fill_in 'Email', with: @user.email
      fill_in "Password", with: @user.password
    # ログインボタンをクリックする
      click_on "Log in"
    # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
  end

  it 'ログインに失敗し、再びサインインページに戻ってくる' do
    # 予め、ユーザーをDBに保存する
      
    # トップページに遷移する
      visit root_path
    # ログインしていない場合、サインインページに遷移していることを確認する
      expect(current_path).to eq new_user_session_path
    # 誤ったユーザー情報を入力する
      @user2 = FactoryBot.create(:user)
      fill_in 'Email', with: "test"
      fill_in 'Password', with: "test"
    # ログインボタンをクリックする
      click_on 'Log in'
    # サインインページに戻ってきていることを確認する
      expect(current_path).to eq new_user_session_path
  end

end