function [c,breakpointval] = break_point(ciphertext2,plaintext2,alpha_p,mij)
for i=1:1:length(ciphertext2)/50
    ciphertext3=ciphertext2((i-1)*50+1:(i*50));
    plaintext3=plaintext2((i-1)*50+1:(i*50));
    if i==1
        cipher=ciphertext3;
        plain=plaintext3;
    else
        cipher=char(cipher,ciphertext3);
        plain=char(plain,plaintext3);
    end
end
orig='abcdefghijklmnopqrstuvwxyz .';
alpha=orig;
%f=1:28;
clear p2 decode p count
z=1;
p2=0;
s=1:28;
cnt=0;
ciphertext2=cipher(1,:);
plaintext2=plain(1,:);

while p2==0
    r=randperm(28,28);
    beta=alpha;
    for i=1:1:28
        beta(s(i))=alpha(r(i));
    end
    decipher2=ciphertext2;
    for k=1:1:length(decipher2)
        idx = strfind(beta,decipher2(k));
        decipher2(k)=orig(idx);
    end
    for k=1:1:length(decipher2)
        if k==1
            idx = strfind(orig,decipher2(k));
            p2=alpha_p(idx)*10;
        else
            idx1 = strfind(orig,decipher2(k-1));
            idx2 = strfind(orig,decipher2(k));
            p2=p2*mij(idx2,idx1)*10;
       end
    end
    cnt=cnt+1;
    alpha=beta;
end
%ciphertext=decipher2;
c=0;
for i=1:1:100000
    decipher1=ciphertext2;
    for k=1:1:length(decipher1)
        idx = strfind(alpha,decipher1(k));
        decipher1(k)=orig(idx);
    end
    for k=1:1:length(decipher1)
        if k==1
            idx = strfind(orig,decipher1(k));
            p1=alpha_p(idx)*10;
        else
            idx1 = strfind(orig,decipher1(k-1));
            idx2 = strfind(orig,decipher1(k));
            p1=p1*mij(idx2,idx1)*10;
        end
    end
    r=randperm(28,2);
    beta=alpha;
    beta(r(1))=alpha(r(2));
    beta(r(2))=alpha(r(1));
    decipher2=ciphertext2;
    for k=1:1:length(decipher2)
        idx = strfind(beta,decipher2(k));
        decipher2(k)=orig(idx);
    end
    for k=1:1:length(decipher2)
        if k==1
            idx = strfind(orig,decipher2(k));
            p2=alpha_p(idx)*10;
        else
            idx1 = strfind(orig,decipher2(k-1));
            idx2 = strfind(orig,decipher2(k));
            p2=p2*mij(idx2,idx1)*10;
        end
    end
    a_x_xprime=binornd(1,min(p2/p1,1));
    if a_x_xprime==1
        alpha=beta;
        p(i)=log(p2);
        decode(i)=nnz(~[decipher2-plaintext2])/length(decipher2);
        count(i)=1;
    else
        p(i)=log(p1);
        decode(i)=nnz(~[decipher1-plaintext2])/length(decipher2);
        count(i)=0;
    end
    if decode(i)>=0.5
        c=1;
        break    
    end
end
clear decode_accuracy
for i=1:1:length(cipher(:,1))
    ciphertext2=cipher(i,:);
    plaintext=plain(i,:);
    decipher1=ciphertext2;
    for k=1:1:length(decipher1)
        idx = strfind(alpha,decipher1(k));
        decipher1(k)=orig(idx);
    end
    decode_accuracy(i)=nnz(~[decipher1-plaintext])/length(decipher1);
end
if c==1
    for i=2:1:length(decode_accuracy)
        if abs(decode_accuracy(i)-decode_accuracy(i-1))>0.2
            breakpointval=50*(i-1)+25;
            break
        end
    end
else
    breakpointval=0;
end
for i=1:1:length(cipher(:,1))
    ciphertext2=cipher(i,:);
    plaintext=plain(i,:);
    decipher1=ciphertext2;
    for k=1:1:length(decipher1)
        idx = strfind(alpha,decipher1(k));
        decipher1(k)=orig(idx);
    end
    decode_accuracy(i)=nnz(~[decipher1-plaintext])/length(decipher1);
end
plot(25+((1:1:length(cipher(:,1)))-1)*50,decode_accuracy);
end

