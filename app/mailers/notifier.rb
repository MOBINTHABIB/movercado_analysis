class Notifier < ActionMailer::Base
  default from: "movercado@gmail.com"

  def suspicious_activity
  	mail(:to => "movercado-jobs@psi.org.mz", :subject => "Final movercado-analysis submission")
  end
end
