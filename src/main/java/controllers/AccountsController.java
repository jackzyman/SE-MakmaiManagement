package controllers;

import databases.AccountsDBConnect;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;
import models.Account;

import java.io.IOException;
import java.util.Optional;

public class AccountsController {
    private Account account;
    private AccountsDBConnect accountsDBConnector;
    @FXML
    private TableView<Account> accountsTableView;
    @FXML private Button deleteButton;

    public void initialize() {
        deleteButton.setDisable(true);
        accountsDBConnector = new AccountsDBConnect();
        accountsTableView.setItems(accountsDBConnector.getAccounts());
        accountsTableView.getSelectionModel().selectedItemProperty().addListener(new ChangeListener<Account>() {
            @Override
            public void changed(ObservableValue<? extends Account> observable, Account oldValue, Account newValue) {
                deleteButton.setDisable(false);
            }
        });
    }
    public void backToHomeOnAction(ActionEvent event) throws IOException {
        Button button = (Button) event.getSource();
        Stage stage = (Stage) button.getScene().getWindow();
        FXMLLoader loader = new FXMLLoader(getClass().getResource("/home.fxml"));
        stage.setScene(new Scene(loader.load()));
        HomeController homeController = loader.getController();
        homeController.setUser(account);
        stage.show();
    }



    public void setUser(Account account) {
        this.account = account;
    }
}
