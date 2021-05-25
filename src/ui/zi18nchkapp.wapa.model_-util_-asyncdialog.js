"use strict";sap.ui.define(["sap/m/Dialog","sap/m/Button"],function(t,o){function i(t,o,i){if(o in t){Object.defineProperty(t,o,{value:i,enumerable:true,configurable:true,writable:true})}else{t[o]=i}return t}class e{constructor(t){this._sTitle=(t===null|+
|t===void 0?void 0:t.title)||"Dialog";this._sWidth=(t===null||t===void 0?void 0:t.width)||"50%";this._sHeight=(t===null||t===void 0?void 0:t.height)||"50%";this._createButtons(t===null||t===void 0?void 0:t.buttons);this._aContent=t===null||t===void 0?voi+
d 0:t.content;this._oModel=t===null||t===void 0?void 0:t.model}async showDialog(o){return new Promise(i=>{this._oDependent=o;this._oDialog=new t({contentHeight:this._sHeight,contentWidth:this._sWidth,draggable:true,content:this._aContent,title:this._sTit+
le,buttons:this._aButtons,afterClose:t=>{var o;i(this._sCloseButton);(o=this._oDependent)===null||o===void 0?void 0:o.removeDependent(this._oDialog);this._oDialog.destroy()}});o===null||o===void 0?void 0:o.addDependent(this._oDialog);if(this._oModel){thi+
s._oDialog.setModel(this._oModel)}this._oDialog.open()})}_createButtons(t){if(t){this._aButtons=[];t.forEach(t=>{if(!!t.text&&!t.icon){return}this._aButtons.push(new o({text:t.text,icon:t.icon,type:t.type||sap.m.ButtonType.Default,press:()=>{var o;this._+
sCloseButton=t.key||t.text;(o=this._oDialog)===null||o===void 0?void 0:o.close()}}))})}if(!this._aButtons){this._aButtons=[new o({text:"{i18n>ok}",press:()=>{var t;this._sCloseButton="ok";(t=this._oDialog)===null||t===void 0?void 0:t.close()}}),new o({te+
xt:"{i18n>cancel}",press:()=>{var t;this._sCloseButton="cancel";(t=this._oDialog)===null||t===void 0?void 0:t.close()}})]}}}i(e,"OK_BUTTON","ok");i(e,"CANCEL_BUTTON","cancel");return e});                                                                    