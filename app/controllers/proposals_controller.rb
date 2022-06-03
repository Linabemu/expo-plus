class ProposalsController < ApplicationController
  def create
  end

  def index
    @expo = Expo.find(params[:expo_id])
    @proposals = @expo.proposals
    @proposal = Proposal.new()
  end
end
