class ApplicationController < ActionController::Base
# 通常は ':exception' となっていますが、Messaging API はこれを通過できないので、
# コメントアウトして、':null_session' に書き換えます。
# protect_from_forgery with: :exception
protect_from_forgery with: :null_session
end
