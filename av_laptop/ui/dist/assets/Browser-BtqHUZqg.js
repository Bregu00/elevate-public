import{c as d,R as w,L as x,r as l,j as e,B as h,G as u,A as c,f as v}from"./index-C4gM3w7B.js";import{T as m}from"./TextInput-C_Q7Mq4o.js";/**
 * @license @tabler/icons-react v3.19.0 - MIT
 *
 * This source code is licensed under the MIT license.
 * See the LICENSE file in the root directory of this source tree.
 */var y=d("outline","arrow-narrow-right","IconArrowNarrowRight",[["path",{d:"M5 12l14 0",key:"svg-0"}],["path",{d:"M15 16l4 -4",key:"svg-1"}],["path",{d:"M15 8l4 4",key:"svg-2"}]]);/**
 * @license @tabler/icons-react v3.19.0 - MIT
 *
 * This source code is licensed under the MIT license.
 * See the LICENSE file in the root directory of this source tree.
 */var j=d("outline","home","IconHome",[["path",{d:"M5 12l-2 0l9 -9l9 9l-2 0",key:"svg-0"}],["path",{d:"M5 12v7a2 2 0 0 0 2 2h10a2 2 0 0 0 2 -2v-7",key:"svg-1"}],["path",{d:"M9 21v-6a2 2 0 0 1 2 -2h2a2 2 0 0 1 2 2v6",key:"svg-2"}]]);const k="_header_1h767_1",f="_input_1h767_17",p={header:k,input:f},b=({url:t})=>e.jsx("div",{style:{width:"100%",height:"100%",position:"relative"},children:e.jsx("iframe",{allowFullScreen:!1,style:{borderStyle:"none"},height:"92%",width:"100%",src:t,title:"Web Browser",sandbox:"allow-scripts allow-same-origin"})}),C=()=>{const t=w(x),[r,a]=l.useState(t.browser.homepage),[o,n]=l.useState(r),g=()=>{n(t.browser.homepage),a(t.browser.homepage)},i=async()=>{const s=await v("av_laptop","website",o);s&&a(s)};return e.jsxs(h,{style:{height:"100%",width:"100%"},bg:"#1C1C1E",children:[e.jsx(h,{className:p.header,children:e.jsxs(u,{justify:"center",w:"100%",gap:"xs",children:[e.jsx(c,{variant:"transparent",color:"dark.1",size:"xs",onClick:()=>{g()},children:e.jsx(j,{stroke:1.5})}),e.jsx(m,{value:o,placeholder:"Navigate",classNames:p,size:"xs",w:"30%",maw:600,onKeyDown:s=>{s.key==="Enter"&&i()},onChange:s=>{n(s.target.value)},rightSection:e.jsx(c,{variant:"light",color:"dark.1",size:"xs",radius:20,onClick:()=>{i()},children:e.jsx(y,{style:{width:"14px",height:"14px"}})})})]})}),e.jsx(b,{url:r})]})};export{C as default};
