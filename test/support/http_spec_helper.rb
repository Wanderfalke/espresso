module HttpSpecHelper
  def ok? response
    check(response.status) == 200
  end

  def ok_body?(val)
    ok? last_response
    val.is_a?(Regexp) ? match_body?(val) : current_body?(val)
  end

  def not_found? response
    check(response.status) == 404
  end

  def not_implemented? response
    check(response.status) == 501
  end

  def current_status?(status)
    is(last_response.status) == status
  end

  def protected? response
    check(last_response.status) == 401
  end

  def authorized? response
    check(last_response.status) == 200
  end

  def current_redirect_code? status=302
    is(status).current_status?
  end

  def current_charset?(charset)
    prove(last_response.header['Content-Type']) =~ %r[charset=#{Regexp.escape charset}]
  end

  def match_last_modified_header?(time)
    prove(last_response.headers['Last-Modified']) == time
  end

  def current_content_type?(type)
    if type[0..0].to_s == '.' # extensions, lookup in mime types
      expect(last_response.header['Content-Type']) =~ %r[#{Rack::Mime::MIME_TYPES.fetch(type)}]
    else
      expect(last_response.header['Content-Type']) == type
    end
  end

  def match_body?(val)
    expect(last_response.body) =~ val
  end

  def current_body? body
    expect(last_response.body) == body
  end

  def current_location?(location)
    is?(last_response.headers['Location']) == location
  end

end
