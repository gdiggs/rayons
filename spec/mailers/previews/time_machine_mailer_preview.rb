class TimeMachineMailerPreview < ActionMailer::Preview
  def daily_summary_preview
    TimeMachineMailer.daily_summary(User.first)
  end
end
