json.form render(partial: "participants/form_participant", formats: :html, locals: {proposal: @proposal, participant: Participant.new})
json.inserted_item render(partial: "participants/avatar_photo", formats: :html, locals: {participant: @participant})

json.participants_count @proposal.participants.count
