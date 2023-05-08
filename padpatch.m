function[t,b,l,r] = padpatch(t,b,l,r,ips,frontside,halfsize,w,h)

  for i=1:1 %size(ips.side)
   
    if (h - ips.side(i,2)) < halfsize   
       b = (h - ips.side(i,2));
    else
       b = halfsize;
    end
    
    if (ips.side(i,2)) < halfsize
        t = ips.side(i,2)-1;
    else
        t = halfsize-1;
    end    
    
    if (w - ips.side(i,1)) < halfsize   
       r = (w - ips.side(i,1));
    else
       r = halfsize;
    end
    
    if (ips.side(i,1)) < halfsize
        l = ips.side(i,1)-1;
    else
        l = halfsize-1;
    end   
    
  end
end