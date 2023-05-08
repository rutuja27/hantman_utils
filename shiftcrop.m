function[ips] = shiftcrop(width,height,ips,frontside,halfsize)

for idx=1:length(ips.side)
   if(~((ips.side(idx,1) + halfsize) < width))
            offx = ips.side(idx,1) + halfsize - width;
            ips.side(idx,1) = ips.side(idx,1) - offx;  
   elseif(~((ips.side(idx,1) - halfsize) >= 1))
            offx = halfsize - ips.side(idx,1);  
            ips.side(idx,1) = ips.side(idx,1) + offx;
   end
        
   if(~((ips.side(idx,2) + halfsize) < height))
       offy = ips.side(idx,2) + halfsize - height;
       ips.side(idx,2) = ips.side(idx,2) - offy;  
   elseif(~((ips.side(idx,2) - halfsize) >= 1))
       offy = halfsize - ips.side(idx,2);  
       ips.side(idx,2) = ips.side(idx,2) + offy;
   end
end

if frontside
    assert(all(isfield(ips,{'front' 'side'})),'Expected fields missing from ips.');
    for idx=1:length(ips.front)
        if(~((ips.front(idx,1) + halfsize) < width))
            offx = ips.front(idx,1) + halfsize - width;
            ips.front(idx,1) = ips.front(idx,1) - offx;  
        elseif(~((ips.front(idx,1) - halfsize) >= 1))
            offx = halfsize - ips.front(idx,1);  
            ips.front(idx,1) = ips.front(idx,1) + offx;
        end
        
        if(~((ips.front(idx,2) + halfsize) < height))
            offy = ips.front(idx,2) + halfsize - height;
            ips.front(idx,2) = ips.front(idx,2) - offy;  
        elseif(~((ips.front(idx,2) - halfsize) >= 1))
            offy = halfsize - ips.front(idx,2);  
            ips.front(idx,2) = ips.front(idx,2) + offy;
        end
    end
end