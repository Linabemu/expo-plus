if @review.persisted?
  json.form render(partial: "reviews/form", formats: :html, locals: {expo: @expo, review: Review.new})
  json.inserted_item render(partial: "expos/review", formats: :html, locals: {review: @review})
else
  json.form render(partial: "reviews/form", formats: :html, locals: {expo: @expo, review: @review})
end
