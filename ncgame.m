clc; clear all;

M = [3 3];  %vetor com número de estratégias de cada jogador
%Matriz de Pay-offs para combinações de estratégias
U = [1,5;
    1,4;
    1,3;
    4,1;
    5,1;
    1,1;
    1,1;
    2,1;
    3,1]
    
p = 1; V = 1; %inicializando as variaveis p e v
n = length(M); %tamanho da maior dimensão da matriz
s = sum(M); %soma dos elementos da matriz m
A = zeros(max(M),n); %inicializando a matriz A
payoff = zeros(1,n); %inicializando a matriz payoff

for i = 1 : n
    p = p * M(1,i);
end

P = zeros(1,n); %inicializando a matriz P
N = zeros(1,n); %inicializando a matriz N
P(n) = 1;

for i = n-1 : -1 : 1    %P=problemas
    P(i) = P(i+1) * M(i+1);
end

for i = 1 : n           
    N(i) = p / P(i);
end

x0 = zeros(s,1); k = 1;

for i = 1 : n
    for j = 1 : M(1,i)
        x0(k) = 1 / M(1,i); k = k + 1;
    end
end

Us = sum(U,2);

for i = 1 : n
    V = V * (1 / M(i)) ^ M(i);
end

x0 = [x0 ; V * (sum(U,1)')];
Aeq = zeros(n,s+n); cnt = 0;

for i = 1 : n
    if i ~= 1
        cnt = cnt + M(i-1);
    end
    for j = 1 : s
        if j <= sum(M(1:i)) &&  j > cnt
            Aeq(i,j) = 1;
        end
    end
end

beq = ones(n,1);
I = ones(p,n);
counter = 0; count = 1;

for i = 1 : n
    for j = 1 : N(i)
        counter = counter + 1;
        if i ~= 1
            if counter > sum(M(1:i))
                counter = counter-M(i);
            end
        end
        for k = 1 : P(i)
            I(count) = counter;
            count = count + 1;
        end
    end
end

lb = zeros(s+n,1);
ub = ones(s+n,1);
pay = zeros(s,1);
counter = 0;

for i = 1 : n
    for j = 1 : M(i)
        counter = counter + 1;
        pay(counter) = i + s;
    end
end

for i = 1 : n
    lb(s+i) = -inf;
    ub(s+i) = inf;
end

[x] = game(n,Us,p,I,s,ub,lb,x0,Aeq,beq,pay,U);
      
count = 0;

for i = 1 : n
    for j = 1 : M(i)
        count = count + 1;
        A(j,i) = abs(x(count));
    end
    payoff(1,i) = x(s+i);
end
payoff