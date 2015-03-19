clear;
close all;
N = 5; % assuming we have N * N points

step = 20;

Vertices = {}; % store all data
VerticesMatrix = zeros(N * N, 2);

n = 0;

for i = 1:N
    for j = 1:N
        n = n + 1;
        Vertices{n} = [i * step, j * step];
        VerticesMatrix(n,:) = Vertices{n};
    end
end

ControlVerticsIndex = [2, 11];
ControlNum = size(ControlVerticsIndex, 2);

p = {};
for i = 1:ControlNum
   p{i} = Vertices{ControlVerticsIndex(i)}; 
end

VerticesNum = size(Vertices, 2);
m_w = ones(VerticesNum, ControlNum);

% compute w
for v = 1:VerticesNum
    for i = 1:ControlNum
        dis = norm(Vertices{v} - p{i})^3;
        if dis >= 1.0
            m_w(v,i) = 1.0 / dis;
        end
    end
end

% compute As and vmp
As = {};
m_vmp = {};

for i = 1:VerticesNum
    v = Vertices{i};
    pStar = GetWeightedMeanForPoint(i, p, m_w);
    pHat = GetCurveAroundMean(p, pStar);
    mu_s = GetWeightedCovarSum(pHat, m_w(i,:));
    m_vmp{i} = v - pStar;
    
    for j = 1:ControlNum
        lh = [pHat{j}(1), pHat{j}(2); pHat{j}(2), -pHat{j}(1)];
        rh = [m_vmp{i}(1), m_vmp{i}(2); m_vmp{i}(2), -m_vmp{i}(1)];
        
        %As{i,j} = lh * rh' * (m_w(i,j)/mu_s);
        As{i,j} = lh * rh' * (m_w(i,j));
    end
end

% set deformed vertices
q = {};
q{1} = p{2} + [0, 20];
q{2} = p{2};

% for i = 1:ControlNum
%    q{i} = p{i} + [2, 3]; 
% end


deformedVerticesMatrix = zeros(size(VerticesMatrix));

for i = 1:VerticesNum
    qStar = GetWeightedMeanForPoint(i, q, m_w);
    qHat = GetCurveAroundMean(q, qStar);
    
    newPoint = zeros(1,2);
    for j = 1:ControlNum
        prod = qHat{j} * As{i,j};
        newPoint = newPoint + prod;
    end
    
    % eqn(8)
    scale = norm(m_vmp{i})/norm(newPoint);
    newPoint = scale * newPoint + qStar;
    deformedVerticesMatrix(i,:) = newPoint;
end

v = deformedVerticesMatrix - VerticesMatrix;
figure;
% quiver(VerticesMatrix(:,1),VerticesMatrix(:,2),v(:,1),v(:,2));
hold on;
plot(VerticesMatrix(:,1),VerticesMatrix(:,2),'.');
hold on;
figure;
plot(deformedVerticesMatrix(:,1), deformedVerticesMatrix(:,2),'*');
hold on;
cp = [q{1};q{2}];
plot(cp(:,1),cp(:,2),'o');




