class ParticipantsController < ApplicationController
  def create

    @proposal = Proposal.find(params[:proposal_id])

    @participant = Participant.where(proposal: @proposal, user: current_user).first_or_create
    # @participant.proposal = @proposal
    # @participant.user = current_user
    # @participant.save

    respond_to do |format|
      format.html { redirect_to expo_proposal_path(@proposal.expo, @proposal) }
      format.json
    end
  end
end
