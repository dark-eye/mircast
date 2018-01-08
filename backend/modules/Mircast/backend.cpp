#include <QtQml>
#include <QtQml/QQmlContext>
#include "backend.h"
#include "launcher.h"


void BackendPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("Mircast"));

    qmlRegisterType<Launcher>(uri, 1, 0, "Launcher");
}

void BackendPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}
