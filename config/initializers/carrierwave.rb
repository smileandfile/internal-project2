CarrierWave.configure do |config|
 config.cache_dir = "#{Rails.root}/tmp/uploads"
 config.azure_storage_account_name = 'snfprod'
 config.azure_storage_access_key = 'gEuhzm0jr8wztr/w1qAPLPzOudoMgXGhEqTSRJ++WBJrqgepv96J5CBO/1ggqpTj80ZX6r/yAxN11kSZ+IymVQ=='
 config.azure_container = 'snfprodstorage'
end
