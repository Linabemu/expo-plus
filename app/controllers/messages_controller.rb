class MessagesController < ApplicationController
  def create
    @proposal = Proposal.find(params[:proposal_id])
    @message = Message.new(message_params)
    @message.proposal = @proposal
    @message.user = current_user
    if @message.save
      ProposalChannel.broadcast_to(
        @proposal,
        message_html: render_to_string(partial: "shared/message", locals: { message: @message }),
        author_id: current_user.id
      )
      head :ok
    else
      redirect_to expo_proposal_path(@proposal.expo, @proposal), status: :unprocessable_entity
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to expo_proposal_path
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
