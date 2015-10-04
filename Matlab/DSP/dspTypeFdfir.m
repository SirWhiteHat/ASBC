classdef dspTypeFdfir < dspType
    properties
        nDim = 2;
        name = 'fdfir'
    end
    
    methods
        function obj = dspTypeFdfir(n)
            obj = obj@dspType(n);
        end
        
        function dim = dimensionSize(self,n)
            switch n
                case 1
                    dim = 2;
                case 2
                    dim = 2 * self.n;
            end
        end
        
        function outFilt = renderFilter(self, f, mag)
            filt = fir2(self.n,f,mag);
            filt = [filt zeros(1,self.n*2-size(filt,2))];
            filt = fft(filt);
            
            outFilt.Real = real(filt)';
            outFilt.Imag = imag(filt)';
        end
    end
end