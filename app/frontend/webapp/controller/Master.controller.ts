import Controller from "sap/ui/core/mvc/Controller";
import formatter from "../model/formatter";
import UIComponent from "sap/ui/core/UIComponent";
import GenericTile from "sap/m/GenericTile";
import { LayoutType } from "sap/f/library";
import UI5Event from "sap/ui/base/Event";
import FilterOperator from "sap/ui/model/FilterOperator";
import Filter from "sap/ui/model/Filter";
import SearchField from "sap/m/SearchField";
import MultiComboBox from "sap/m/MultiComboBox";
import Panel from "sap/m/Panel";
import ListBinding from "sap/ui/model/ListBinding";


/**
 * @namespace flexso.htf.frontend.frontend.controller
 */
export default class Master extends Controller {
  public formatter = formatter;

  /*eslint-disable @typescript-eslint/no-empty-function*/
  public onInit(): void {}

  private pressPlanet(event: UI5Event) {
    (this.getOwnerComponent() as UIComponent).getRouter().navTo("Detail", {
      GalaxyId: (event.getSource() as GenericTile)
        ?.getBindingContext()
        ?.getProperty("ID") as number,
      layout: LayoutType.TwoColumnsBeginExpanded,
    });
  }

  private onSearch(event: UI5Event) {
    const oView = this.getView()!;
    const oSearchField = oView.byId("id.SearchField") as SearchField;

    const oList = this.byId("idHrmSystemsPane") as any;
    const oBinding = oList.getBinding("content");

    const aFilters: Filter[] = [];
    const query = oSearchField.getValue();
    if (query) {
      aFilters.push(new Filter("name", FilterOperator.Contains, query));
    }

    oBinding.filter(aFilters); // Apply filter to the binding
  }

  public clearFilters(event: UI5Event): void {
    const oView = this.getView()!;
    const oSearchField = oView.byId("id.SearchField") as SearchField;
    const oComboBox = oView.byId("id.AlienStatusComboBox") as MultiComboBox;
    const oPanel = oView.byId("idHrmSystemsPane") as Panel;
    const oBinding = oPanel.getBinding("content") as ListBinding;

    // Clear search field
    oSearchField.setValue("");

    // Clear selected keys in the MultiComboBox
    oComboBox.setSelectedKeys([]);

    // Remove any applied filters
    if (oBinding) {
      oBinding.filter([], "Application");
    }
  }
}
