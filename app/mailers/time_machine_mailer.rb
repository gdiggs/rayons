class TimeMachineMailer < ApplicationMailer
  default from: "Rayons Time Machine <time@rayons.info>"
  helper ItemsHelper

  def daily_summary(user)
    @user = user
    @time_machine = TimeMachine.new

    mail(to: @user.email, subject: "Daily Rayons Time Machine")
  end
end
