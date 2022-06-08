class ParticipantsController < ApplicationController
  def create
    @participant = Participant.new(proposal_id: params[:id], user_id: current_user.id)
    @participant.save
  end
end
