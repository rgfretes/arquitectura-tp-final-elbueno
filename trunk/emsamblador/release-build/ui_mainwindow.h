/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 5.2.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QToolBar>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralWidget;
    QLabel *labelBienvenido;
    QLabel *labelSeleccionRuta;
    QPushButton *botonBrowse;
    QLineEdit *DireccionArchivoLineEdit;
    QLabel *labelSeleccionNombreSalida;
    QLineEdit *nombreArchivoSalidaLineEdit;
    QPushButton *botonEnsamblar;
    QLabel *labelCantidadEnsanblada;
    QMenuBar *menuBar;
    QToolBar *mainToolBar;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QStringLiteral("MainWindow"));
        MainWindow->resize(400, 300);
        centralWidget = new QWidget(MainWindow);
        centralWidget->setObjectName(QStringLiteral("centralWidget"));
        labelBienvenido = new QLabel(centralWidget);
        labelBienvenido->setObjectName(QStringLiteral("labelBienvenido"));
        labelBienvenido->setGeometry(QRect(160, 10, 71, 21));
        labelSeleccionRuta = new QLabel(centralWidget);
        labelSeleccionRuta->setObjectName(QStringLiteral("labelSeleccionRuta"));
        labelSeleccionRuta->setGeometry(QRect(10, 60, 321, 31));
        botonBrowse = new QPushButton(centralWidget);
        botonBrowse->setObjectName(QStringLiteral("botonBrowse"));
        botonBrowse->setGeometry(QRect(10, 90, 75, 23));
        DireccionArchivoLineEdit = new QLineEdit(centralWidget);
        DireccionArchivoLineEdit->setObjectName(QStringLiteral("DireccionArchivoLineEdit"));
        DireccionArchivoLineEdit->setGeometry(QRect(100, 90, 241, 20));
        labelSeleccionNombreSalida = new QLabel(centralWidget);
        labelSeleccionNombreSalida->setObjectName(QStringLiteral("labelSeleccionNombreSalida"));
        labelSeleccionNombreSalida->setGeometry(QRect(10, 120, 261, 16));
        nombreArchivoSalidaLineEdit = new QLineEdit(centralWidget);
        nombreArchivoSalidaLineEdit->setObjectName(QStringLiteral("nombreArchivoSalidaLineEdit"));
        nombreArchivoSalidaLineEdit->setGeometry(QRect(10, 140, 331, 20));
        botonEnsamblar = new QPushButton(centralWidget);
        botonEnsamblar->setObjectName(QStringLiteral("botonEnsamblar"));
        botonEnsamblar->setGeometry(QRect(140, 210, 75, 23));
        labelCantidadEnsanblada = new QLabel(centralWidget);
        labelCantidadEnsanblada->setObjectName(QStringLiteral("labelCantidadEnsanblada"));
        labelCantidadEnsanblada->setGeometry(QRect(20, 170, 351, 31));
        MainWindow->setCentralWidget(centralWidget);
        menuBar = new QMenuBar(MainWindow);
        menuBar->setObjectName(QStringLiteral("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 400, 21));
        MainWindow->setMenuBar(menuBar);
        mainToolBar = new QToolBar(MainWindow);
        mainToolBar->setObjectName(QStringLiteral("mainToolBar"));
        MainWindow->addToolBar(Qt::TopToolBarArea, mainToolBar);
        statusBar = new QStatusBar(MainWindow);
        statusBar->setObjectName(QStringLiteral("statusBar"));
        MainWindow->setStatusBar(statusBar);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "MainWindow", 0));
        labelBienvenido->setText(QApplication::translate("MainWindow", "Bienvenido", 0));
        labelSeleccionRuta->setText(QApplication::translate("MainWindow", "Seleccione la ruta del archivo fuente que desea ensamblar", 0));
        botonBrowse->setText(QApplication::translate("MainWindow", "browse", 0));
        labelSeleccionNombreSalida->setText(QApplication::translate("MainWindow", "Seleccione el nombre del archivo de salida", 0));
        botonEnsamblar->setText(QApplication::translate("MainWindow", "Ensamblar", 0));
        labelCantidadEnsanblada->setText(QString());
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
