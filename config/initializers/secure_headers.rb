SecureHeaders::Configuration.default do |config|
  config.csp.merge!(
    script_src: %w[
      'unsafe-eval'
      'unsafe-inline'
      'self'
      d2wy8f7a9ursnm.cloudfront.net
      www.google-analytics.com
      www.gstatic.com
    ],
    style_src: %w[
      'unsafe-inline'
      'self'
      fonts.googleapis.com
      www.gstatic.com
    ],
  )
end
