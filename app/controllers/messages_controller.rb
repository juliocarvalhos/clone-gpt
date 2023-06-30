class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: %i[ show edit update destroy ]
  before_action :set_conversation, only: [:new, :create]

  # GET /messages or /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/new
  def new
    @message = @conversation.messages.build
  end

  # POST /messages or /messages.json
  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    respond_to do |format|

      if @message.save
        @conversation.text = @message.text if @conversation.text == ""
        @conversation.save
        response_text = generate_response(@message.text)
        @response = @message.build_response(text: response_text)
        @response.save
        format.html { redirect_to conversation_path(@message.conversation) }
        format.json { render :show, status: :created, location: @message }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to message_url(@message), notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:user_id, :text)
    end

  def generate_response(prompt)
    api_key = "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"
    engine = "text-davinci-003"

    openai_client = OpenAI::Client.new(api_key: api_key, default_engine: engine)
    response = openai_client.completions(prompt: prompt, max_tokens: 1000, engine: engine)
    text = response.choices[0].text
  end
end
