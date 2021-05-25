"use strict";sap.ui.define(["sap/ui/core/UIComponent","sap/f/FlexibleColumnLayoutSemanticHelper","sap/base/util/UriParameters","./model/models","./model/customIcons"],function(e,t,o,n,i){function u(e){return e&&e.__esModule&&typeof e.default!=="undefined+
"?e.default:e}const l=u(n);const s=e.extend("devepos.i18ncheck.Component",{metadata:{manifest:"json"},init:function t(){e.prototype.init.apply(this,arguments);this.getRouter().initialize();this.setModel(l.createDeviceModel(),"device");this._oLayoutModel=+
l.createViewModel();this.setModel(this._oLayoutModel,"layout")},getLayoutModel:function e(){return this._oLayoutModel},getResourceBundle:function e(){if(!this._oBundle){var t;this._oBundle=(t=this.getModel("i18n"))===null||t===void 0?void 0:t.getResource+
Bundle()}return this._oBundle},getHelper:function e(){const n=this.getRootControl().byId("flexColLayout");const i=new o(window.location.href);const u={defaultTwoColumnLayoutType:sap.f.LayoutType.TwoColumnsMidExpanded,defaultThreeColumnLayoutType:sap.f.La+
youtType.ThreeColumnsMidExpanded,mode:i.get("mode"),initialColumnsCount:i.get("initial"),maxColumnsCount:i.get("max")};return t.getInstanceFor(n,u)},destroy:function t(){e.prototype.destroy.apply(this,arguments)}});return s});                             