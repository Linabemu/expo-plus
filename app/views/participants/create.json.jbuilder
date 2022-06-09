json.form render(partial: "participants/form_participant", formats: :html, locals: {proposal: @proposal, participant: Participant.new})
json.inserted_item render(partial: "XXXX/XXXX", formats: :html, locals: {participant: @participant})
