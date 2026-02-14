package com.posapp;

import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.stage.Stage;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;

/**
 * PosApp - Portable Point of Sale Application
 * A simple, portable POS system that runs with bundled Java Runtime
 */
public class PosApp extends Application {

    @Override
    public void start(Stage primaryStage) {
        primaryStage.setTitle("PosApp - Portable Point of Sale System");

        // Create main layout
        BorderPane mainLayout = new BorderPane();
        mainLayout.setPadding(new Insets(15));

        // Header
        Label headerLabel = new Label("Point of Sale System");
        headerLabel.setFont(Font.font("System", FontWeight.BOLD, 24));
        HBox headerBox = new HBox(headerLabel);
        headerBox.setAlignment(Pos.CENTER);
        headerBox.setPadding(new Insets(0, 0, 20, 0));
        mainLayout.setTop(headerBox);

        // Center content - Product list and cart
        GridPane centerGrid = new GridPane();
        centerGrid.setHgap(10);
        centerGrid.setVgap(10);
        centerGrid.setPadding(new Insets(10));

        // Products section
        Label productsLabel = new Label("Products");
        productsLabel.setFont(Font.font("System", FontWeight.BOLD, 16));
        centerGrid.add(productsLabel, 0, 0);

        ListView<String> productList = new ListView<>();
        productList.getItems().addAll(
            "Apple - $1.50",
            "Banana - $0.75",
            "Orange - $1.25",
            "Bread - $2.50",
            "Milk - $3.00",
            "Eggs - $4.50",
            "Coffee - $8.99",
            "Tea - $5.99"
        );
        productList.setPrefHeight(300);
        centerGrid.add(productList, 0, 1);

        // Cart section
        Label cartLabel = new Label("Shopping Cart");
        cartLabel.setFont(Font.font("System", FontWeight.BOLD, 16));
        centerGrid.add(cartLabel, 1, 0);

        ListView<String> cartList = new ListView<>();
        cartList.setPrefHeight(300);
        centerGrid.add(cartList, 1, 1);

        // Buttons
        VBox buttonBox = new VBox(10);
        Button addButton = new Button("Add to Cart");
        Button removeButton = new Button("Remove from Cart");
        Button clearButton = new Button("Clear Cart");
        
        addButton.setMaxWidth(Double.MAX_VALUE);
        removeButton.setMaxWidth(Double.MAX_VALUE);
        clearButton.setMaxWidth(Double.MAX_VALUE);
        
        buttonBox.getChildren().addAll(addButton, removeButton, clearButton);
        centerGrid.add(buttonBox, 2, 1);

        mainLayout.setCenter(centerGrid);

        // Bottom - Total and checkout
        HBox bottomBox = new HBox(15);
        bottomBox.setAlignment(Pos.CENTER_RIGHT);
        bottomBox.setPadding(new Insets(20, 0, 0, 0));

        Label totalLabel = new Label("Total: $0.00");
        totalLabel.setFont(Font.font("System", FontWeight.BOLD, 18));
        
        Button checkoutButton = new Button("Checkout");
        checkoutButton.setFont(Font.font("System", FontWeight.BOLD, 14));
        checkoutButton.setStyle("-fx-background-color: #4CAF50; -fx-text-fill: white;");
        
        bottomBox.getChildren().addAll(totalLabel, checkoutButton);
        mainLayout.setBottom(bottomBox);

        // Event handlers
        final double[] total = {0.0};
        
        addButton.setOnAction(e -> {
            String selected = productList.getSelectionModel().getSelectedItem();
            if (selected != null) {
                cartList.getItems().add(selected);
                // Extract price and add to total
                String priceStr = selected.substring(selected.indexOf("$") + 1);
                double price = Double.parseDouble(priceStr);
                total[0] += price;
                totalLabel.setText(String.format("Total: $%.2f", total[0]));
            }
        });

        removeButton.setOnAction(e -> {
            String selected = cartList.getSelectionModel().getSelectedItem();
            if (selected != null) {
                cartList.getItems().remove(selected);
                // Extract price and subtract from total
                String priceStr = selected.substring(selected.indexOf("$") + 1);
                double price = Double.parseDouble(priceStr);
                total[0] -= price;
                totalLabel.setText(String.format("Total: $%.2f", total[0]));
            }
        });

        clearButton.setOnAction(e -> {
            cartList.getItems().clear();
            total[0] = 0.0;
            totalLabel.setText("Total: $0.00");
        });

        checkoutButton.setOnAction(e -> {
            if (cartList.getItems().isEmpty()) {
                showAlert("Cart is empty", "Please add items to cart before checkout.");
            } else {
                showAlert("Checkout Complete", 
                    String.format("Total amount: $%.2f\nThank you for your purchase!", total[0]));
                cartList.getItems().clear();
                total[0] = 0.0;
                totalLabel.setText("Total: $0.00");
            }
        });

        // Create scene and show
        Scene scene = new Scene(mainLayout, 900, 500);
        primaryStage.setScene(scene);
        primaryStage.show();

        // Show welcome message
        showAlert("Welcome to PosApp", 
            "Portable Point of Sale System\nVersion 1.0.0\n\n✅ No Java installation required\n✅ Runs from any location");
    }

    private void showAlert(String title, String content) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(content);
        alert.showAndWait();
    }

    public static void main(String[] args) {
        launch(args);
    }
}
