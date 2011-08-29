function listDescription(){new Ajax.Updater('description', "#{params[:username]}/#{params[:list]}", { 
	method: 'post', 
	parameters: { description: 'list' },
	onSuccess: function(){new Effect.Appear('description', {duration: 0.3 });}
	});}

function listTweets(){	new Ajax.Updater('tweets', "#{params[:username]}/#{params[:list]}", { 
	method: 'post',
	parameters: { type: 'list' }
	});}

function userDescription(){		new Ajax.Updater('description', "#{params[:username]}", { 
	method: 'post', 
	parameters: { description: 'user' },
	onSuccess: function(){new Effect.Appear('description', {duration: 0.3 });}
	});}


function userTweets(){			new Ajax.Updater('tweets', "#{params[:username]}", { 
	method: 'post',
	parameters: { type: 'user' },
	});}
	
function homeTweets(){	new Ajax.Updater('tweets', "sutterbomb/topsecret", { 
	method: 'post',
	parameters: { type: 'list' }
	});}
	
function homeDescription(){new Ajax.Updater('description', "sutterbomb/topsecret", { 
	method: 'post', 
	parameters: { description: 'list' },
	onSuccess: function(){new Effect.Appear('description', {duration: 0.3 });}
	});}

//spinner from fgnass.github.com/spin.js
(function(a,b,c){function O(a){H(arguments,function(b,d){a[b]===c&&(a[b]=d)});return a}function N(a){H(arguments,function(b,c){a[m][M(a,b)||b]=c});return a}function M(a,b){var d=a[m],f,g;if(d[b]!==c)return b;b=b.charAt(0).toUpperCase()+b.slice(1);for(g=0;g<E[e];g++){f=E[g]+b;if(d[f]!==c)return f}}function L(a,b){var c=[j,b,~~(a*100)].join("-"),d="{"+j+":"+a+"}",f;if(!F[c]){for(f=0;f<E[e];f++)try{K.insertRule("@"+(E[f]&&"-"+E[f].toLowerCase()+"-"||"")+"keyframes "+c+"{0%{"+j+":1}"+b+"%"+d+"to"+d+"}",K.cssRules[e])}catch(g){}F[c]=1}return c}function J(a,b,c){c&&!c[t]&&J(a,c),a.insertBefore(b,c||null);return a}function I(a){var c=b.createElement(a||"div");H(arguments,function(a,b){c[a]=b});return c}function H(a,b){var c=~~((a[e]-1)/2);for(var d=1;d<=c;d++)b(a[d*2-1],a[d*2])}var d="width",e="length",f="radius",g="lines",h="trail",i="color",j="opacity",k="speed",l="shadow",m="style",n="height",o="left",p="top",q="px",r="childNodes",s="firstChild",t="parentNode",u="position",v="relative",w="absolute",x="animation",y="transform",z="Origin",A="Timeout",B="coord",C="#555",D=m+"Sheets",E="webkit0Moz0ms0O".split(0),F={},G;J(b.getElementsByTagName("head")[0],I(m));var K=b[D][b[D][e]-1],P=function(a){this.opts=O(a||{},g,12,h,100,e,7,d,5,f,10,i,C,j,.25,k,1)},Q=P.prototype={spin:function(b){var c=this,d=c.el=c[g](c.opts);b&&J(b,N(d,o,~~(b.offsetWidth/2)+q,p,~~(b.offsetHeight/2)+q),b[s]);if(!G){var e=c.opts,f=0,i=20/e[k],l=(1-e[j])/(i*e[h]/100),m=i/e[g];(function n(){f++;for(var b=e[g];b;b--){var h=Math.max(1-(f+b*m)%i*l,e[j]);c[j](d,e[g]-b,h,e)}c[A]=c.el&&a["set"+A](n,50)})()}return c},stop:function(){var b=this,d=b.el;a["clear"+A](b[A]),d&&d[t]&&d[t].removeChild(d),b.el=c;return b}};Q[g]=function(a){function s(b,c){return N(I(),u,w,d,a[e]+a[d]+q,n,a[d]+q,"background",b,"boxShadow",c,y+z,o,y,"rotate("+~~(360/a[g]*m)+"deg) translate("+a[f]+q+",0)","borderRadius","100em")}var b=N(I(),u,v),c=L(a[j],a[h]),m=0,r;for(;m<a[g];m++)r=N(I(),u,w,p,1+~(a[d]/2)+q,y,"translate3d(0,0,0)",x,c+" "+1/a[k]+"s linear infinite "+(1/a[g]/a[k]*m-1/a[k])+"s"),a[l]&&J(r,N(s(C,"0 0 4px "+C),p,2+q)),J(b,J(r,s(a[i],"0 0 1px rgba(0,0,0,.1)")));return b},Q[j]=function(a,b,c){a[r][b][m][j]=c};var R="behavior",S="url(#default#VML)",T="group0roundrect0fill0stroke".split(0);(function(){var a=N(I(T[0]),R,S),b;if(!M(a,y)&&a.adj){for(b=0;b<T[e];b++)K.addRule(T[b],R+":"+S);Q[g]=function(){function s(c,e,l){J(k,J(N(h(),"rotation",360/a[g]*c+"deg",o,~~e),J(N(I(T[1],"arcsize",1),d,b,n,a[d],o,a[f],p,-a[d]/2,"filter",l),I(T[2],i,a[i],j,a[j]),I(T[3],j,0))))}function h(){return N(I(T[0],B+"size",c+" "+c,B+z,-b+" "+ -b),d,c,n,c)}var a=this.opts,b=a[e]+a[d],c=2*b,k=h(),m=~(a[e]+a[f]+a[d])+q,r;if(a[l])for(r=1;r<=a[g];r++)s(r,-2,"progid:DXImage"+y+".Microsoft.Blur(pixel"+f+"=2,make"+l+"=1,"+l+j+"=.3)");for(r=1;r<=a[g];r++)s(r);return J(N(I(),"margin",m+" 0 0 "+m,u,v),k)},Q[j]=function(a,b,c,d){d=d[l]&&d[g]||0,a[s][r][b+d][s][s][j]=c}}else G=M(a,x)})(),a.Spinner=P})(window,document)