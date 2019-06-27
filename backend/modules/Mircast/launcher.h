#ifndef LAUNCHER_H
#define LAUNCHER_H

#include <QObject>
#include <QProcess>
#include <QFileInfo>

class Launcher : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString output READ output NOTIFY outputChanged )
    Q_PROPERTY( QString remoteIP READ remoteIP WRITE setRemoteIP)
    Q_PROPERTY( uint width READ width WRITE setWidth)
    Q_PROPERTY( uint height READ height WRITE setHeight)
    Q_PROPERTY( uint port READ port WRITE setPort)
    Q_PROPERTY( ushort compression READ compression WRITE setCompression )
    Q_PROPERTY( bool active READ isActive NOTIFY activeChanged )
	Q_PROPERTY( bool canHost READ canHost NOTIFY abilityChanged )
	Q_PROPERTY( bool canCast READ canCast NOTIFY abilityChanged )

public:
    explicit Launcher(QObject *parent = 0);
    Q_INVOKABLE bool cast();
    Q_INVOKABLE bool host();
    Q_INVOKABLE bool stop();
    Q_INVOKABLE QString getCommandOutput();
	Q_INVOKABLE QString getCastCommand();
	Q_INVOKABLE QString getHostCommand();
    ~Launcher();

Q_SIGNALS:
    void outputChanged();
    void activeChanged();
	void abilityChanged();

public slots:
    void updateActive();
    void updateOutputMsg();
	void commandChanged();


protected:
    bool launch(QString command);
    QString output() { return m_message; }
    QString remoteIP() { return m_remoteIP; }
    void setRemoteIP(QString ip) { m_remoteIP = ip; }
    uint width() { return m_width; }
    void setWidth(uint width) { m_width = width; }
    uint height() { return m_height; }
    void setHeight(uint height) { m_height = height; }
    uint port() { return m_port; }
    void setPort(uint port) { m_port = port; }
    uint compression() { return m_compression; }
    void setCompression(uint port) { m_compression = port; }

    bool isActive();
	bool canHost();
	bool canCast();


    QString m_message;
    QProcess *m_process;
    uint m_width;
    uint m_height;
    QString m_remoteIP;
    uint m_port;
    ushort m_compression;
    bool m_active;
};

#endif // LAUNCHER_H
