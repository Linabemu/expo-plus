json.form render(partial: "participants/form_participant", formats: :html, locals: {proposal: @proposal, participant: Participant.new})
json.already_exists @already_exists
unless @already_exists
  json.inserted_item render(partial: "participants/avatar_photo", formats: :html, locals: {participant: @participant})
end
json.participants_count @proposal.participants.count
