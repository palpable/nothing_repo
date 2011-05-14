module RoomsHelper
  
   def youtube_addr(addr)
    url = addr.split('=')
    if  url[1] != nil
      uniqid = url[1].split('&')
      @uniqueid = uniqid[0]
      return true
    else
      return false
    end

  end
end
