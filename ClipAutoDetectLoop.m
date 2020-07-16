function p=ClipAutoDetectLoop(s,th,sigma)

    % ss: the input record
    % th: the input threshold for peak amplitude
    ss=s;    %Copy the input s to ss.
    r=(rand(size(ss))-0.5)*sigma*max(ss);% Generate a tiny random serial r.
    ss=ss+r; % Add r to the signal copy ss to avoid the failure for exactly equal or locally rebounding waveform around the peak amplitudes.
    gg=diff(ss);      %Obtain the first-order gradient.
    p=zeros(size(gg));%Initializing array p, which is used to mark the Clipped Sample. 0: unclipped; otherwise: clipped.

    for jj=2:size(gg,1)-2
        if (sign(gg(jj)*gg(jj+1))<=0 ) %if adjacent two gradients are in opposite sign, each should be temporarily marked as Clipped Sample.
            p(jj)=ss(jj); 
            p(jj+1)=ss(jj+1);
        end
    end

    for jj=1:size(gg,1)
        if ss(jj)<th*max(ss) && ss(jj)>th*min(ss) %Exclude those under the threshold th.
            p(jj)=0;
        end
    end

    for jj=2:size(ss,1)-1 %%This part is for Back-to-zero type.
        if abs(ss(jj)-ss(jj-1))+abs(ss(jj+1)-ss(jj))>th*max(ss)&& (abs(ss(jj+1))>th*max(ss)||abs(ss(jj))<0.01*max(ss)) %If the gradient is absurdly large (say, about half of the peak amplitude), mark it by assigning it as peak amplitude (the sign is from its right neighbour). 
            p(jj)=sign(ss(jj+1))*abs(max(ss));
            p(jj+1)=sign(ss(jj+1))*abs(max(ss));
        end
    end
    for jj=2:size(ss,1)-2 %%This part is for Back-to-zero type.
        if abs(ss(jj)-ss(jj-1))+abs(ss(jj+2)-ss(jj+1))>th*max(ss) && (abs(ss(jj+2))>th*max(ss)||(abs(ss(jj))<0.01*max(ss)&&abs(ss(jj+1))<0.01*max(ss)))%If two adjacent samples are absurdly large (say, about half of the peak amplitude), mark it by assigning it as peak amplitude (the sign is from its right neighbour). 
            p(jj)=sign(ss(jj+2))*abs(max(ss));
            p(jj+1)=sign(ss(jj+2))*abs(max(ss));
        end
    end

    for jj=2:size(p,1)-1
        if abs(p(jj-1))>0 && abs(p(jj+1))>0 && abs(p(jj))==0 %Mark the single unmarked sample that is between two marked samples.
            p(jj)=ss(jj);
        end
    end
    for jj=2:size(p,1)-2
        if abs(p(jj-1))>0 && abs(p(jj+2))>0  && abs(p(jj+1))==0 && abs(p(jj))==0 %Mark the two unmarked samples that are between two marked samples.
            p(jj)=ss(jj);
            p(jj+1)=ss(jj+1);
        end
    end
    for jj=2:size(p,1)-3
        if abs(p(jj-1))>0 && abs(p(jj+3))>0  && abs(p(jj+1))==0 && abs(p(jj))==0 && abs(p(jj+2))==0%Mark the three unmarked samples that are between two marked samples.
            p(jj)=ss(jj);
            p(jj+1)=ss(jj+1);
            p(jj+2)=ss(jj+2);
        end
    end
    for jj=2:size(p,1)-4
        if abs(p(jj-1))>0 && abs(p(jj+4))>0  && abs(p(jj+1))==0 && abs(p(jj))==0 && abs(p(jj+2))==0 && abs(p(jj+3))==0%Mark the four unmarked samples that are between two marked samples.
            p(jj)=ss(jj);
            p(jj+1)=ss(jj+1);
            p(jj+2)=ss(jj+2);
            p(jj+3)=ss(jj+3);
        end
    end
    for jj=2:size(p,1)-5
        if abs(p(jj-1))>0 && abs(p(jj+5))>0  && abs(p(jj+1))==0 && abs(p(jj))==0 && abs(p(jj+2))==0 && abs(p(jj+3))==0 && abs(p(jj+4))==0%Mark the five unmarked samples that are between two marked samples.
            p(jj)=ss(jj);
            p(jj+1)=ss(jj+1);
            p(jj+2)=ss(jj+2);
            p(jj+3)=ss(jj+3);
            p(jj+4)=ss(jj+4);
        end
    end

    for jj=2:size(p,1)-1 %%This part is for Back-to-zero type.
        if p(jj-1)==0 && p(jj+1)==0 && abs(p(jj))>0 %Exclude the local single marked sample.
            p(jj)=0;
        end
    end
    for jj=2:size(p,1)-2 %%This part is for Back-to-zero type.
        if p(jj-1)==0 && p(jj+2)==0 && abs(p(jj))>0 &&abs(p(jj+1))>0%Exclude local two marked samples.
            p(jj  )=0;
            p(jj+1)=0;
        end
    end
    for jj=2:size(p,1)-3 %%This part is for Back-to-zero type.
        if p(jj-1)==0 && p(jj+3)==0 && abs(p(jj))>0 && abs(p(jj+1))>0 && abs(p(jj+2))>0 %Exclude local three marked samples.
            p(jj  )=0;
            p(jj+1)=0;
            p(jj+2)=0;
        end
    end
    for jj=2:size(p,1)-4 %%This part is for Back-to-zero type.
        if p(jj-1)==0 && p(jj+4)==0 && abs(p(jj))>0 && abs(p(jj+1))>0 && abs(p(jj+2))>0 && abs(p(jj+3))>0 %Exclude local four marked samples.
            p(jj  )=0;
            p(jj+1)=0;
            p(jj+2)=0;
            p(jj+3)=0;
        end
    end
    for jj=2:size(p,1)-5 %%This part is for Back-to-zero type.
        if p(jj-1)==0 && p(jj+5)==0 && abs(p(jj))>0 && abs(p(jj+1))>0 && abs(p(jj+2))>0 && abs(p(jj+3))>0 && abs(p(jj+4))>0%Exclude local five marked samples.
            p(jj  )=0;
            p(jj+1)=0;
            p(jj+2)=0;
            p(jj+3)=0;
            p(jj+4)=0;
        end
    end
end