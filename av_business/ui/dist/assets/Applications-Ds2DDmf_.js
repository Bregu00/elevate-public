import{o as h,R as j,H as I,L as M,r as l,j as s,B as n,b as C,G as o,T as c,a as L,P,f as p}from"./index-D1DpFFbG.js";import{f as w}from"./formatTime-Dbt9Fc1W.js";/**
 * @license @tabler/icons-react v3.5.0 - MIT
 *
 * This source code is licensed under the MIT license.
 * See the LICENSE file in the root directory of this source tree.
 */var N=h("outline","mail","IconMail",[["path",{d:"M3 7a2 2 0 0 1 2 -2h14a2 2 0 0 1 2 2v10a2 2 0 0 1 -2 2h-14a2 2 0 0 1 -2 -2v-10z",key:"svg-0"}],["path",{d:"M3 7l9 6l9 -6",key:"svg-1"}]]);/**
 * @license @tabler/icons-react v3.5.0 - MIT
 *
 * This source code is licensed under the MIT license.
 * See the LICENSE file in the root directory of this source tree.
 */var B=h("outline","phone","IconPhone",[["path",{d:"M5 4h4l2 5l-2.5 1.5a11 11 0 0 0 5 5l1.5 -2.5l5 2v4a2 2 0 0 1 -2 2a16 16 0 0 1 -15 -15a2 2 0 0 1 2 -2",key:"svg-0"}]]);/**
 * @license @tabler/icons-react v3.5.0 - MIT
 *
 * This source code is licensed under the MIT license.
 * See the LICENSE file in the root directory of this source tree.
 */var R=h("outline","user","IconUser",[["path",{d:"M8 7a4 4 0 1 0 8 0a4 4 0 0 0 -8 0",key:"svg-0"}],["path",{d:"M6 21v-2a4 4 0 0 1 4 -4h4a4 4 0 0 1 4 4v2",key:"svg-1"}]]);const S="_card_18sx8_1",T="_description_18sx8_13",A="_copy_18sx8_25",r={card:S,description:T,copy:A},G=()=>{const x=j(I),f=j(M),{appplications:a}=f,[t,m]=l.useState(!0),[d,g]=l.useState([]),[y,v]=l.useState(!1),_=()=>{m(!t),p("av_business","toggleApplications",t)},u=e=>{p("av_laptop","copy",e)};return l.useEffect(()=>{(async()=>{const i=await p("av_business","getApplications"),z=i.applications.sort((k,b)=>b.date-k.date);g(z),m(i.status),setTimeout(()=>{v(!0)},100)})()},[]),s.jsx(s.Fragment,{children:y?s.jsxs(n,{h:x>900?"calc(100%)":"calc(95%)",children:[s.jsxs(o,{justify:"space-between",align:"center",display:"flex",children:[s.jsx(c,{fz:"md",fw:500,children:`${d.length} ${a.header}`}),s.jsx(L,{size:"xs",variant:"light",color:t?"teal.4":"red.4",onClick:_,children:t?a.open:a.closed})]}),s.jsx(n,{mt:"md",h:x>900?"calc(90%)":"calc(80%)",style:{overflow:"auto"},children:d.map((e,i)=>s.jsxs(P,{p:"sm",className:r.card,mb:"xs",mah:155,children:[s.jsxs(o,{gap:5,children:[s.jsx(R,{stroke:1.5,size:14}),s.jsx(c,{fz:"sm",c:"gray.5",children:e==null?void 0:e.name})]}),s.jsx(n,{mt:"xs",className:r.description,children:s.jsx(c,{fz:"sm",children:e==null?void 0:e.description})}),s.jsxs(o,{justify:"space-between",mt:"xs",children:[s.jsxs(n,{display:"flex",children:[s.jsxs(o,{gap:5,children:[s.jsx(B,{stroke:1.5,size:14}),s.jsx(c,{fz:"sm",onClick:()=>{u(e==null?void 0:e.phone)},className:r.copy,children:e==null?void 0:e.phone})]}),s.jsxs(o,{gap:5,ml:"md",children:[s.jsx(N,{stroke:1.5,size:14}),s.jsx(c,{fz:"sm",onClick:()=>{u(e==null?void 0:e.email)},className:r.copy,children:e==null?void 0:e.email})]})]}),s.jsx(c,{c:"dimmed",fz:"sm",children:w(e.date)})]})]},i))})]}):s.jsx(n,{style:{display:"flex",alignContent:"center",alignItems:"center",height:"100%"},children:s.jsx(C,{visible:!0,zIndex:1e3,loaderProps:{color:"teal",type:"dots"},overlayProps:{radius:"sm",blur:2,opacity:0}})})})};export{G as default};
