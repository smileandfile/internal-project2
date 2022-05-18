Prome.configure do |config|
  # Prome also responds to :histogram, :gauge, :summary, just register what you want :)
  # Prome.counter(:aspone_signins_total, 'A counter of total number of sign ins.')

  Prome.histogram(:aspone_gstn_request_duration_seconds, 'A histogram of latency to GSTN endpoints.')

  Prome.counter(:aspone_gstn_error_response_codes, 'A counter response codes from GSTN endpoints.')

  Prome.counter(:aspone_gstn_response_codes, 'A counter response codes from GSTN endpoints.')

  Prome.counter(:aspone_gstn_requests_total, 'A counter of number of GSTN requests received.')

  Prome.counter(:aspone_gstn_fallbacks_total, 'A counter of number of GSTN requests made including fallback and auth.')
end
