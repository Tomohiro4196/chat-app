class MessagesController < ApplicationController
  def index
    @message = Message.new
    @room = Room.find(params[:room_id])
    #params内のroom_idを取得
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
