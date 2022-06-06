class ProposalsController < ApplicationController

  def new
    @expo = Expo.find(params[:expo_id])
    @proposal = Proposal.new
  end

  def create
    @expo = Expo.find(params[:expo_id])
    @proposal = Proposal.new(proposal_params)
    @proposal.user = current_user
    @proposal.expo = @expo
    if @proposal.save
      redirect_to expo_proposals_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @expo = Expo.find(params[:expo_id])
    @proposals = @expo.proposals
    @proposal = Proposal.new
  end

  def destroy
    @proposal = Proposal.find(params[:id])
    @proposal.destroy
    redirect_to expo_proposals_path
  end


  private

  def proposal_params
    params.require(:proposal).permit(:description, :date_proposale)
  end
end
