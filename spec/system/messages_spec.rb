require 'rails_helper'

RSpec.describe "Messages", type: :system do
  before do
    # 中間テーブルを作成して、usersテーブルとroomsテーブルのレコードを作成する
    @room_user = FactoryBot.create(:room_user)
  end

  context '投稿に失敗したとき' do
    it '送る値が空の為、メッセージの送信に失敗すること' do
      # サインインする #sign_in_support.ebで設定したsign_inメソッドを使う
      sign_in(@room_user.user)
      

      # beforeアクションで作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # DBに保存されていないことを確認する
      expect{find('input[name = "commit"]').click}.to change{Message.count}.by(0)
      # 元のページに戻ってくることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room.id)

    end
  end

  context '投稿に成功したとき' do
    it 'テキストの投稿に成功すると、投稿一覧に遷移して、投稿した内容が表示されている' do
      # サインインする
        sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
        click_on(@room_user.room.name)

      # 値をテキストフォームに入力する
        @message = FactoryBot.build(:message)
        fill_in "message_content", with: @message.content

      # 送信した値がDBに保存されていることを確認する
        expect{find("input[name = 'commit']").click}.to change{Message.count}.by(1)

      # 投稿一覧画面に遷移していることを確認する
        expect(current_path).to eq room_messages_path(@room_user.room.id)
      # 送信した値がブラウザに表示されていることを確認する
        expect(page).to have_content(@message.content)
    end

    it '画像の投稿に成功すると、投稿一覧に遷移して、投稿した画像が表示されている' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')

      # 画像選択フォームに画像を添付する
      attach_file('message[image]', image_path, make_visible: true)

      # 送信した値がDBに保存されていることを確認する
        expect{find("input[name = 'commit']").click}.to change{Message.count}.by(1)
      # 投稿一覧画面に遷移していることを確認する
        expect(current_path).to eq room_messages_path(@room_user.room.id)
      # 送信した画像がブラウザに表示されていることを確認する
        expect(page).to have_selector("img")
        #image_tagがimgタグを生成する #imgタグであって文字列ではないからhave_contentは使えない
    end

    it 'テキストと画像の投稿に成功すること' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')

      # 画像選択フォームに画像を添付する
      attach_file('message[image]', image_path, make_visible: true)

      # 値をテキストフォームに入力する
      @message = FactoryBot.build(:message)
      fill_in 'message_content', with: @message.content

      # 送信した値がDBに保存されていることを確認する
      expect{find("input[name = 'commit']").click}.to change{Message.count}.by(1)

      # 送信した値がブラウザに表示されていることを確認する
      expect(page).to have_selector(".mgs_contents")

      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector("img")

    end

    it 'チャットルームを削除すると、関連するメッセージがすべて削除されていること' do
      # サインインする
      sign_in(@room_user.user)
  
      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)
  
      # メッセージ情報を5つDBに追加する
      FactoryBot.create_list(:message, 5, room_id: @room_user.room.id, user_id: @room_user.user.id) 
        #:message -> messageテーブル, 5 -> 5つのレコード, room_id: user_id: -> ルームId・ユーザーIDを固定で設定

      # 「チャットを終了する」ボタンをクリックすることで、作成した5つのメッセージが削除されていることを確認する
      expect {
        find_link("チャットを終了する",  href: room_path(@room_user.room)).click
      }.to change { @room_user.room.messages.count }.by(-5)

      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
    end

  end
end
