class ParticipantsController < ApplicationController
  def create
    # @participant = Participant.new(proposal_id: params[:id], user_id: current_user.id)
    @proposal = Proposal.find(params[:proposal_id])
    @participant = Participant.new
    @participant.proposal = @proposal

    respond_to do |format|
      @participant.save
      format.html { redirect_to expo_proposal_path(@proposal.expo, @proposal) }
      format.json
    end
  end
end
