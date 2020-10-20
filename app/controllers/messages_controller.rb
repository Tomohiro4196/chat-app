class MessagesController < ApplicationController
  def index
    @message = Message.new
    #messageモデルのインスタンス情報を代入
    @room = Room.find(params[:room_id])
    #params内のroom_idを取得
    @messages = @room.messages.includes(:user)
    #@room.messages = roomに紐づいているmessage全て -> @messages(複数形)と定義
    #includesをつけることで大量のアクセスを１度で済ませる(N+1問題の解決)
  end

  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_params)
       #@room.message.newで現在のチャットルームに紐づいたメッセージのインスタンスを作成
    #privateメソッド(message_params)で内容を指定
     if  @message.save
       #saveメソッドで保存→保存できたらメッセージ画面へリダイレクト
        redirect_to room_messages_path(@room.id)
     else
        @room.messages.includes(:user)
        #@messagesを定義して、元々あるレコードを次のindexで表示する
        render :index
        #元のページに戻る
     end
 
  end



  private
  def message_params
    params.require(:message).permit(:content).merge(user_id: current_user.id)
    #contentのみを保存。
    #ログインしているユーザーのIDをmergeして、current_user.idのみが紐づいているmessageを受け取る
  end
end
