# frozen_string_literal: true

# TODO: Run `rake insert:users` just after next deploy

namespace :insert do
  task users: :environment do
    votes = Vote.distinct(:user_id).select(:user_id, :user_name)
    votes.each { |vote| User.create id: vote.user_id, name: vote.user_name }
  end
end
