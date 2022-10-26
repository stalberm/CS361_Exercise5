# Exercise 6
class ParticpantExtractor
  def initialize(participants_email_string)
    @participants_email_string = participants_email_string
  end

  def extract_participants
    return if @participants_email_string.blank?
    @participants_email_string.split.uniq.map do |email_address|
      User.create(email: email_address.downcase, password: Devise.friendly_token)
    end
  end

end

class LaunchDiscussionWorkflow

  def initialize(discussion, host, participants)
    @discussion = discussion
    @host = host
    @participants = participants
  end

  def run
    return unless valid?
    run_callbacks(:create) do
      ActiveRecord::Base.transaction do
        discussion.save!
        create_discussion_roles!
        @successful = true
      end
    end
  end

  # ...

end


participant_email_string = "fake1@example.com\nfake2@example.com\nfake3@example.com"
participant_extractor = ParticpantExtractor.new(participant_email_string)

participants = participant_extractor.extract_participants
discussion = Discussion.new(title: "fake", ...)
host = User.find(42)
workflow = LaunchDiscussionWorkflow.new(discussion, host, participants)
workflow.run