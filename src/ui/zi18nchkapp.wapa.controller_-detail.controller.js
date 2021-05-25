"use strict";sap.ui.define(["./BaseController","../model/formatter","../model/models","../model/dataAccess/rest/RepositoryInfoService","../model/dataAccess/rest/CheckI18nService","../model/util/AsyncDialog","sap/base/Log","sap/base/strings/formatMessage"+
,"sap/m/MessageToast","sap/ui/core/Fragment"],function(e,t,o,n,s,i,a,l,r,c){function u(e){return e&&e.__esModule&&typeof e.default!=="undefined"?e.default:e}const d=u(e);const g=u(t);const h=u(o);const f=u(n);const p=u(s);const m=u(i);const y=d.extend("d+
evepos.i18ncheck.controller.Detail",{constructor:function e(){d.prototype.constructor.apply(this,arguments);this.formatter=g;this.formatMessage=l},onInit:function e(){d.prototype.onInit.call(this);this._oBundle=this.getOwnerComponent().getResourceBundle(+
);this._oViewModel=h.createViewModel({excludeActionEnabled:false,includeActionEnabled:false,busy:false});this._oTable=this.byId("i18nMessages");this.getView().setModel(this._oViewModel,"viewModel");this.oRouter.getRoute("main").attachPatternMatched(this.+
_onRouteMatched,this);this.oRouter.getRoute("detail").attachPatternMatched(this._onRouteMatched,this)},onMessageTableSelectionChange:function e(){let t=false;let o=false;for(const e of this._oTable.getSelectedContexts()){if(e.getProperty("ignEntryUuid"))+
{o=true}else{t=true}}this._oViewModel.setProperty("/excludeActionEnabled",t);this._oViewModel.setProperty("/includeActionEnabled",o)},onAssignGitRepo:async function e(t){const o=this.getView().getBindingContext();const n=o===null||o===void 0?void 0:o.get+
Object();if(!n){return}const s=h.createViewModel({url:n.gitUrl});const i=new m({title:this._oBundle.getText("gitRepositoryAssignDialogTitle"),width:"45em",height:"8em",content:await c.load({type:"XML",name:"devepos.i18ncheck.fragment.ChangeGitRepo"}),mod+
el:s});const l=await i.showDialog(this.getView());if(l!==m.OK_BUTTON){return}const u=s.getProperty("/url");if(u===n.gitUrl){return}try{const e=new f;await e.updateRepoInfo({bspName:n.bspName,gitUrl:u});o.getModel().setProperty(`${o.sPath}/gitUrl`,u);r.sh+
ow(this._oBundle.getText("gitRepoUrlUpdated",n.bspName))}catch(e){a.error(e)}},onExcludeMessages:async function e(){this._createIgnoreMessageEntries(e=>!e.ignEntryUuid,e=>({messageType:e.messageType,filePath:e.file.path,fileName:e.file.name,i18nKey:e.key+
}),this._updateIgnoreEntries.bind(this))},onIncludeMessages:async function e(){this._createIgnoreMessageEntries(e=>!!e.ignEntryUuid,e=>({ignEntryUuid:e.ignEntryUuid}),this._clearIgnoredKeyFromEntries.bind(this),true)},onItemPress:function e(t){},onFullSc+
reen:function e(){const t=this.oLayoutModel.getProperty("/actionButtonsInfo/midColumn/fullScreen");this.getRouter().navTo("detail",{layout:t,resultPath:encodeURIComponent(this._sResultPath)})},onExitFullScreen:function e(){const t=this.oLayoutModel.getPr+
operty("/actionButtonsInfo/midColumn/exitFullScreen");this.getRouter().navTo("detail",{layout:t,resultPath:encodeURIComponent(this._sResultPath)})},onClose:function e(){var t=this.oLayoutModel.getProperty("/actionButtonsInfo/midColumn/closeColumn");this.+
getRouter().navTo("main",{layout:t})},_onRouteMatched:function e(t){const o=decodeURIComponent(t.getParameter("arguments").resultPath)||this._sResultPath||"";if(o){this._sResultPath=o}this.getView().bindElement({path:o})},_createIgnoreMessageEntries:asyn+
c function e(t,o,n,s){var i;const l=this._oTable.getSelectedContexts();if((l===null||l===void 0?void 0:l.length)<=0){return}const c=(i=this.getView().getBindingContext())===null||i===void 0?void 0:i.getObject();if(!c){return}this._oViewModel.setProperty(+
"/busy",true);const u=[];const d=[];for(const e of l){const n=e.getObject();if(!t(n)){continue}d.push(e);u.push(Object.assign({bspName:c.bspName},o(n)))}if(u.length>0){try{var g;const e=new p;const t=s?await e.deleteIgnoredMessages(u):await e.ignoreMessa+
ges(u);if((t===null||t===void 0?void 0:(g=t.data)===null||g===void 0?void 0:g.length)>0){var h;n(t.data,d);this.getOwnerComponent().getModel().updateBindings();this._oTable.removeSelections();const e=s?"messagesIncludedSuccess":"messagesExcludedSuccess";+
r.show(this._oBundle.getText(e,t===null||t===void 0?void 0:(h=t.data)===null||h===void 0?void 0:h.length))}}catch(e){if(e!==null&&e!==void 0&&e.statusText){a.error(e.statusText)}else{a.error(e)}}}this._oViewModel.setProperty("/busy",false)},_clearIgnored+
KeyFromEntries:function e(t,o){if((t===null||t===void 0?void 0:t.length)!==(o===null||o===void 0?void 0:o.length)){return}for(const e of o){const t=e.getObject();t.ignEntryUuid=""}},_updateIgnoreEntries:function e(t,o){if((t===null||t===void 0?void 0:t.l+
ength)!==(o===null||o===void 0?void 0:o.length)){return}for(const e of o){const o=e.getObject();const n=t.find(e=>e.fileName===o.file.name&&e.filePath===o.file.path&&e.messageType===o.messageType&&e.i18nKey===o.key);if(n){o.ignEntryUuid=n.ignEntryUuid}}}+
});return y});                                                                                                                                                                                                                                                 