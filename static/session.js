(function(){
var S={stars:'bjjmap-stars',watched:'bjjmap-watched',queue:'bjjmap-queue',recent:'bjjmap-recent'};
function get(k, d){ try{var v=JSON.parse(localStorage.getItem(k)); return v==null?d:v;}catch(e){return d;}}
function set(k,v){ try{localStorage.setItem(k, JSON.stringify(v));}catch(e){}}
// Stars on node pages: toggle button #star-btn[data-node]
var starBtn=document.getElementById('star-btn');
if(starBtn){ var nid=starBtn.dataset.node, stars=get(S.stars,[]); function refreshStar(){ var on=stars.indexOf(nid)>-1; starBtn.textContent=on?'★ In my game':'☆ My game'; starBtn.setAttribute('aria-pressed', on); } refreshStar(); starBtn.addEventListener('click', function(){ stars=get(S.stars,[]); var i=stars.indexOf(nid); if(i>-1) stars.splice(i,1); else stars.push(nid); set(S.stars,stars); refreshStar(); }); }
// Watched checkboxes on video facades
document.querySelectorAll('.video-card').forEach(function(card){
  var yid=(card.querySelector('.facade')||{}).dataset||{}; yid=yid.yid; if(!yid) return;
  var w=get(S.watched,{}); var cb=document.createElement('input'); cb.type='checkbox'; cb.className='watched-toggle'; cb.setAttribute('aria-label','Mark watched'); cb.checked=!!w[yid];
  if(cb.checked) card.classList.add('watched'); cb.addEventListener('change', function(){ var m=get(S.watched,{}); if(cb.checked) m[yid]=1; else delete m[yid]; set(S.watched,m); card.classList.toggle('watched', cb.checked);});
  var head=card.querySelector('.video-heading'); if(head) head.appendChild(cb);
});
// Drill queue
var qbar=document.getElementById('drill-queue'); // optional container
var queue=get(S.queue,[]);
function renderQueue(){ if(!qbar) return; qbar.innerHTML=''; queue.forEach(function(id,i){ var d=document.createElement('div'); d.textContent=id; var rm=document.createElement('button'); rm.textContent='×'; rm.addEventListener('click',function(){queue.splice(i,1); set(S.queue,queue); renderQueue();}); d.appendChild(rm); qbar.appendChild(d);}); var share=document.getElementById('drill-share'); if(share) share.href=location.origin+location.pathname+'?drill='+queue.join(','); }
renderQueue();
// Add-to-queue buttons on node pages
document.querySelectorAll('[data-add-drill]').forEach(function(b){ b.addEventListener('click', function(){ var id=b.dataset.addDrill; if(queue.indexOf(id)===-1){queue.push(id); set(S.queue,queue); renderQueue();}}); });
// ?drill= reconstruction
var p=new URLSearchParams(location.search); var dr=p.get('drill'); if(dr){ var ids=dr.split(',').map(function(s){return s.trim();}).filter(Boolean); set(S.queue, ids); queue=ids; renderQueue(); }
// Recently viewed in header
try{ var here=location.pathname.match(/\/node\/([^\/]+)/); if(here){ set(S.recent, here[1]); } var recent=get(S.recent,''); if(recent && !here){ var nav=document.querySelector('.primary-nav'); if(nav && !document.getElementById('recent-link')){ var a=document.createElement('a'); a.id='recent-link'; a.className='nav-link'; a.href='/node/'+encodeURIComponent(recent)+'/'; a.textContent='Recent: '+recent; nav.appendChild(a); } } }catch(e){}
})();
