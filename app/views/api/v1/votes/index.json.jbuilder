# frozen_string_literal: true

json.array! @votes, partial: 'api/v1/votes/vote', as: :vote
