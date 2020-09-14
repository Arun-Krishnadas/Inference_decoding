function [d,alpha,decipher1,decode_accuracy] = decode_function_break(ciphertext2,plaintext2,alpha_p,mij,kval)
c_orig=ciphertext2;
p_orig=plaintext2;
n=length(ciphertext2);
if n>=250
    for i=1:1:length(ciphertext2)/250
        ciphertext3=ciphertext2((i-1)*250+1:(i*250));
        plaintext3=plaintext2((i-1)*250+1:(i*250));
        if i==1
            cipher=ciphertext3;
            plain=plaintext3;
        else
            cipher=char(cipher,ciphertext3);
            plain=char(plain,plaintext3);
        end
    end
    c=1;
else
    cipher=ciphertext2;
    plain=plaintext2;
    c=0;
end
orig='abcdefghijklmnopqrstuvwxyz .';
alpha=orig;
clear p2 decode p count
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
d=0;
for i=1:1:10000
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
        decode(i)=nnz(~[decipher2-plaintext2])/length(decipher2);
    else
        p(i)=log(p1);
        decode(i)=nnz(~[decipher1-plaintext2])/length(decipher2);
    end
    if c==1
        if kval<=5
            if decode(i)>=0.95 
                d=1;
                break
            end
        else
            if decode(i)>=0.85
                d=1;
                break;
            end
        end
    else
        if n<150
            if decode(i)>0.5
                d=1;
                break
            end
        else
            if decode(i)>0.7
                d=1;
                break
            end
        end
    end
end
decipher1=c_orig;
for k=1:1:length(c_orig)
    idx = strfind(alpha,decipher1(k));
    decipher1(k)=orig(idx);
end
decode_accuracy=nnz(~[decipher1-p_orig])/length(decipher1);
figure
plot(decode,'k-','LineWidth',2);
xlabel('Iteration count');
ylabel('Decode accuracy');
end



