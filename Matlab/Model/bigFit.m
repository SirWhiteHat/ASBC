function [ fit ] = bigFit(  )

contourRef = ISO226();

fSize = 20;
depthSize = 20;
phonRefSize = 20;

f = linspace(20,12500,fSize);
depth = linspace(10,40,depthSize);
phonRef = linspace (40,90,phonRefSize);

fit = zeros(fSize, phonRefSize, depthSize);

for c = 1:depthSize
    for b = 1:phonRefSize
            for a = 1:fSize
                phonRefLevels = 10;
                contours = zeros(phonRefLevels,1);
                phonRefs = linspace(phonRef(b)-depth(c), phonRef(b), phonRefLevels);
                for phon = 1:phonRefLevels
                    contours(phon) = contourRef.getSPL(phonRefs(phon),f(a));
                end

                out = polyfit(phonRefs.',contours,1);
                fit(a,b,c) = out(1);
            end
        end
    end


end

