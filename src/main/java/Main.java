import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.paint.Color;
import javafx.stage.Stage;
import javafx.stage.StageStyle;

public class Main extends Application {
    @Override
    public void start(Stage stage) throws Exception {


        Parent root = FXMLLoader.load(getClass().getResource("/login.fxml"));

        Scene scene = new Scene(root);

        scene.setFill(Color.DARKGRAY);

//        stage.setScene(new Scene(root, 800, 600));

        stage.setScene(scene);

        stage.initStyle(StageStyle.DECORATED);


        stage.show();

//        Parent root = FXMLLoader.load(getClass().getResource("/LoginView.fxml"));
//        primaryStage.setTitle("The Water");
//        primaryStage.setScene(new Scene(root, 1080, 600));
//        primaryStage.setResizable(false);
//        primaryStage.show();
    }


    public static void main(String[] args) {
        launch(args);
    }
}