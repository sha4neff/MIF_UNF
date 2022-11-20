// ---- Работа с сессиями ----
Процедура СтартТранзакции()
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.БЗ_TSDAPI_Сессии");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Блокировка.Заблокировать();	
КонецПроцедуры

Процедура НоваяСессия()
	ПараметрыСессии=Новый Структура("Операция,Режим","Авторизация","");
	СТСессия=БЗ_TSDRU.Сессия();
	СТСессия.Очистить();
	СТСессия.Вставить("Сессия",Строка(Новый УникальныйИдентификатор()));
	СТСессия.Вставить("Сотрудник",Справочники.БЗ_Сотрудники_ТСД.ПустаяСсылка());
	СТСессия.Вставить("ЗапросВремя",ТекущаяДата());
	СТСессия.Вставить("ЗапросНомер",0);
	СТСессия.Вставить("ЗапросОтвет","");
	СТСессия.Вставить("ТСДНомер",ПолучитьПоле(БЗ_TSDRU.Запрос().data,","));
	СТСессия.Вставить("ТСДМодель",СледующееПоле(БЗ_TSDRU.Запрос().data,","));	
	СТСессия.Вставить("ПараметрыСессии",ПараметрыСессии);
	БЗ_TSDRU.ВременныеПеременные().Очистить();	
	БЗ_TSDRU.Сессия().Вставить("НачальныеПараметры","");
КонецПроцедуры

Процедура ВосстановитьДанныеСессии() Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	БЗ_TSDAPI_Сессии.Сессия КАК Сессия
	|ИЗ
	|	РегистрСведений.БЗ_TSDAPI_Сессии КАК БЗ_TSDAPI_Сессии
	|ГДЕ
	|	БЗ_TSDAPI_Сессии.Сотрудник = &Сотрудник И БЗ_TSDAPI_Сессии.Сессия<>&Сессия");
	Запрос.УстановитьПараметр("Сессия",Строка(БЗ_TSDRU.Сессия().Сессия));
	Запрос.УстановитьПараметр("Сотрудник",БЗ_TSDRU.Сессия().Сотрудник);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Если Выборка.Следующий() Тогда
		НаборЗаписей=РегистрыСведений.БЗ_TSDAPI_Сессии.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Сессия.Установить(Выборка.Сессия);
		НаборЗаписей.Прочитать();
		Сессия=НаборЗаписей.Получить(0);		
		БЗ_TSDRU.Сессия().ПараметрыСессии=Сессия.ПараметрыСессии.Получить();
		НаборЗаписей.Очистить();
		НаборЗаписей.Записать(Истина);
		Если БЗ_TSDRU.Сессия().ПараметрыСессии.Операция="Авторизация" Тогда
			БЗ_TSDRU.Сессия().ПараметрыСессии.Режим="ВыборРМ";
		КонецЕсли;
		БЗ_TSDAPI.ВыполнитьОперацию(БЗ_TSDRU.Сессия().ПараметрыСессии.Операция,БЗ_TSDRU.Сессия().ПараметрыСессии.Режим,Ложь);
	Иначе
		БЗ_TSDAPI.ВыполнитьОперацию("Авторизация","ВыборРМ");
	КонецЕсли;
КонецПроцедуры

Процедура СохранитьДанныеСессии()
	СТСессия=БЗ_TSDRU.Сессия();
	Если БЗ_TSDRU.Ответ().Свойство("payload_type") Тогда
		Если БЗ_TSDRU.Ответ().payload_type="disconnect" Тогда
			НаборЗаписей=РегистрыСведений.БЗ_TSDAPI_Сессии.СоздатьНаборЗаписей();			
			НаборЗаписей.Отбор.Сессия.Установить(СТСессия.Сессия);
			НаборЗаписей.Записать(Истина);
			Возврат;
		КонецЕсли;
	КонецЕсли;			
	Если СТСессия.НачальныеПараметры<>ЗначениеВСтрокуВнутр(СТСессия.Сотрудник)+ЗначениеВСтрокуВнутр(СТСессия.ПараметрыСессии) Тогда
		СтартТранзакции();
		НаборЗаписей=РегистрыСведений.БЗ_TSDAPI_Сессии.СоздатьНаборЗаписей();			
		НаборЗаписей.Отбор.Сессия.Установить(СТСессия.Сессия);
		СтрокаНабора=НаборЗаписей.Добавить();
		СтрокаНабора.Сотрудник=СТСессия.Сотрудник;
		СтрокаНабора.Сессия=СТСессия.Сессия;	
		СтрокаНабора.ЗапросВремя=СТСессия.ЗапросВремя;
		СтрокаНабора.ТСДНомер=СТСессия.ТСДНомер;
		СтрокаНабора.ТСДМодель=СТСессия.ТСДМодель;
		СтрокаНабора.ПараметрыСессии=Новый ХранилищеЗначения(СТСессия.ПараметрыСессии);
		НаборЗаписей.Записать(Истина);
		ЗафиксироватьТранзакцию();
	КонецЕсли;
	ПараметрыСеанса.БЗ_TSDAPI_ДанныеСеанса=Новый ХранилищеЗначения(Новый Структура("Сессия,ВременныеПеременные",БЗ_TSDRU.Сессия(),БЗ_TSDRU.ВременныеПеременные()));
КонецПроцедуры

Функция ИнициализацияСессии()
	Если БЗ_TSDRU.Сессия().Количество()=0 Тогда		
		НоваяСессия();
	Иначе
		ДанныеСессии=РегистрыСведений.БЗ_TSDAPI_Сессии.Получить(Новый Структура("Сессия",БЗ_TSDRU.Сессия().Сессия));
		Если ЗначениеЗаполнено(ДанныеСессии.ЗапросВремя) Тогда
			БЗ_TSDRU.Сессия().ЗапросВремя=ТекущаяДата();
			БЗ_TSDRU.Сессия().Вставить("НачальныеПараметры",ЗначениеВСтрокуВнутр(БЗ_TSDRU.Сессия().Сотрудник)+ЗначениеВСтрокуВнутр(БЗ_TSDRU.Сессия().ПараметрыСессии));
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	Возврат Истина;
КонецФункции

Процедура УдалитьПросроченныеСессии() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	БЗ_TSDAPI_Сессии.Сессия КАК Сессия
	|ИЗ
	|	РегистрСведений.БЗ_TSDAPI_Сессии КАК БЗ_TSDAPI_Сессии
	|ГДЕ
	|	БЗ_TSDAPI_Сессии.ЗапросВремя < &Время";
	Запрос.УстановитьПараметр("Время", ТекущаяДата()-10800);
	СтартТранзакции();
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Пока Выборка.Следующий() Цикл
		НаборЗаписей=РегистрыСведений.БЗ_TSDAPI_Сессии.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Сессия.Установить(Выборка.Сессия);
		НаборЗаписей.Записать(Истина);
	КонецЦикла;
	ЗафиксироватьТранзакцию();
КонецПроцедуры

// ---- Системные функции ----
Процедура ВыполнитьОперацию(Операция,Режим="",ОчисткаПараметровСессии=Истина,ПередатьПараметры=Неопределено,ОчисткаВременныеПеременные=Истина,ПередатьПеременные=Неопределено) Экспорт
	// Используется при переходе из одной операции в другую
	СТСессия=БЗ_TSDRU.Сессия();
	СТЗапрос=БЗ_TSDRU.Запрос();
	СТЗапрос.action="";
	СТЗапрос.data="";
	Если СТСессия.ПараметрыСессии.Свойство("Участок") Тогда
		Участок=СТСессия.ПараметрыСессии.Участок;
	Иначе
		Участок=Справочники.БЗ_Участки.ПустаяСсылка();
	КонецЕсли;
	Если СТСессия.ПараметрыСессии.Свойство("РабочееМесто") Тогда
		РабочееМесто=СТСессия.ПараметрыСессии.РабочееМесто;
	Иначе
		РабочееМесто=Справочники.БЗ_РабочиеМеста.ПустаяСсылка();
	КонецЕсли;	
	Если ОчисткаПараметровСессии Тогда
		Если ЗначениеЗаполнено(ПередатьПараметры) Тогда
			Для Каждого ЭлементСтруктуры Из ПередатьПараметры Цикл
  				СТСессия.ПараметрыСессии.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
			КонецЦикла;
		Иначе
			СТСессия.ПараметрыСессии=Новый Структура();
			СТСессия.ПараметрыСессии.Вставить("Участок",Участок);
			СТСессия.ПараметрыСессии.Вставить("РабочееМесто",РабочееМесто);
		КонецЕсли;
	КонецЕсли;
	Если ОчисткаВременныеПеременные Тогда
		Если ЗначениеЗаполнено(ПередатьПеременные) Тогда
			ВременныеПеременные=БЗ_TSDRU.ВременныеПеременные();
			Для Каждого ЭлементСтруктуры Из ПередатьПеременные Цикл
  				ВременныеПеременные.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
			КонецЦикла;
		Иначе
			БЗ_TSDRU.ВременныеПеременные().Очистить();			
		КонецЕсли;
	КонецЕсли;	
	СТСессия.ПараметрыСессии.Вставить("Режим",Режим);
	СТСессия.ПараметрыСессии.Вставить("Операция",Операция);		
	Выполнить("Обработки.БЗ_TSDAPI_"+Операция+".ОбработчикОперации()");	
КонецПроцедуры 

Процедура ПоказатьОшибку(Текст,ТипДанных="",СобытиеЗакрытия="",ЦветФормы="",РазмерШрифта="",Звук="error") Экспорт
	Если ЗначениеЗаполнено(ТипДанных) Тогда
		ИнициализацияПакетаОтвета(ТипДанных);
	КонецЕсли;
	СТОшибка=Новый Структура();
	СТОшибка.Вставить("text",Текст);
	Если ЗначениеЗаполнено(СобытиеЗакрытия) Тогда
		СТОшибка.Вставить("action",СобытиеЗакрытия);
	КонецЕсли;
	Если ЗначениеЗаполнено(ЦветФормы) Тогда
		СТОшибка.Вставить("form_color",СобытиеЗакрытия);
	КонецЕсли;
	Если ЗначениеЗаполнено(РазмерШрифта) Тогда
		СТОшибка.Вставить("font_size",РазмерШрифта);
	КонецЕсли;
	БЗ_TSDRU.Ответ().Вставить("make_error",СТОшибка);
	Если ЗначениеЗаполнено(Звук) Тогда
		БЗ_TSDRU.Ответ().Вставить("play_sound",Звук);
	КонецЕсли;
КонецПроцедуры

Процедура ЗадатьВопрос(Текст,Вариант1,Вариант2,ВыбратьОтвет,ТипДанных="",Событие1="",Событие2="",ЦветФормы="",РазмерШрифта="19",Звук="info",
	ЦветТекста="", ЦветТекстаВыделенияОтвета="", ЦветФонаВыделенияОтвета="") Экспорт
	Если ЗначениеЗаполнено(ТипДанных) Тогда
		ИнициализацияПакетаОтвета(ТипДанных);
	КонецЕсли;
	СТОшибка=Новый Структура();
	СТОшибка.Вставить("text",Текст);
	СТОшибка.Вставить("answer1",Вариант1);
	СТОшибка.Вставить("answer2",Вариант2);
	СТОшибка.Вставить("default",ВыбратьОтвет);
	Если ЗначениеЗаполнено(Вариант1) Тогда
		СТОшибка.Вставить("answer1",Вариант1);
	КонецЕсли;
	Если ЗначениеЗаполнено(Вариант2) Тогда
		СТОшибка.Вставить("answer2",Вариант2);
	КонецЕсли;	
	Если ЗначениеЗаполнено(Событие1) Тогда
		СТОшибка.Вставить("action1",Событие1);
	КонецЕсли;
	Если ЗначениеЗаполнено(Событие2) Тогда
		СТОшибка.Вставить("action2",Событие2);
	КонецЕсли;
	Если ЗначениеЗаполнено(ЦветФормы) Тогда
		СТОшибка.Вставить("form_color",ЦветФормы);
	КонецЕсли;
	Если ЗначениеЗаполнено(РазмерШрифта) Тогда
		СТОшибка.Вставить("font_size",РазмерШрифта);
	КонецЕсли;
	Если ЗначениеЗаполнено(ЦветТекста) Тогда
		СТОшибка.Вставить("font_color",ЦветТекста);
	КонецЕсли;
	Если ЗначениеЗаполнено(ЦветТекстаВыделенияОтвета) Тогда
		СТОшибка.Вставить("answer_color",ЦветТекстаВыделенияОтвета);
	КонецЕсли;
	Если ЗначениеЗаполнено(ЦветФонаВыделенияОтвета) Тогда
		СТОшибка.Вставить("answer_bgcolor",ЦветФонаВыделенияОтвета);
	КонецЕсли;
	БЗ_TSDRU.Ответ().Вставить("ask_question",СТОшибка);
	Если ЗначениеЗаполнено(Звук) Тогда
		БЗ_TSDRU.Ответ().Вставить("play_sound",Звук);
	КонецЕсли;
КонецПроцедуры

Процедура ИнициализацияПакетаОтвета(ТипДанных,Переинициализация=Ложь) Экспорт
	СТОтвет=БЗ_TSDRU.Ответ();
	СТСессия=БЗ_TSDRU.Сессия();	
	Если Не Переинициализация Тогда // Если повторный вызов без переинициализации выходим
		Если СТОтвет.Свойство("result") Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	СТОтвет.Вставить("result",200);
	СТОтвет.Вставить("session",СТСессия.Сессия);
	СТОтвет.Вставить("req_count",СТСессия.ЗапросНомер);
	СТОтвет.Вставить("payload_type",ТипДанных);
	СТОтвет.Вставить("payload",Новый Структура());
КонецПроцедуры

Процедура ПустойОтветНаЗапрос() Экспорт
	СТОтвет=БЗ_TSDRU.Ответ();
	СТСессия=БЗ_TSDRU.Сессия();	
	СТОтвет.Вставить("result",200);
	СТОтвет.Вставить("session",СТСессия.Сессия);
	СТОтвет.Вставить("req_count",СТСессия.ЗапросНомер);
	СТОтвет.Вставить("payload_type",БЗ_TSDRU.ТипыФреймов().empty);
	СТОтвет.Вставить("payload",Новый Структура());	
КонецПроцедуры

// ---- Общие функции ----
Функция ПолучитьПоле(Стр,Разделитель) Экспорт
	Если Найти(Стр,Разделитель) = 0 Тогда	
		Возврат Стр;
	Иначе 	
		Возврат Лев(Стр,Найти(Стр,Разделитель)-1);
	КонецЕсли;
КонецФункции

Функция СледующееПоле(Стр,Разделитель) Экспорт
	Если Найти(Стр,Разделитель) = 0 Тогда
		Возврат "";
	Иначе
		Возврат Прав(Стр,СтрДлина(Стр)-(Найти(Стр,Разделитель)+(СтрДлина(Разделитель)-1)));
	КонецЕсли;
КонецФункции

Функция ОбрезатьСтроку(Стр,КолСимволов) Экспорт
	Если СтрДлина(Стр)>КолСимволов Тогда
		Возврат Лев(Стр,КолСимволов)+"...";
	Иначе
		Возврат Стр;
	КонецЕсли;
КонецФункции

Функция ПолучитьВыбраннуюСтроку(Данные) Экспорт
	Попытка
		СТЗапрос=БЗ_TSDRU.Запрос();
		Если СТЗапрос.action="key" Тогда
			Если СтрДлина(СТЗапрос.data)=4 Тогда
				Возврат Неопределено;
			Иначе
				Позиция=Число(Прав(СТЗапрос.data,СтрДлина(СТЗапрос.data)-4));
				Строка=Данные.Получить(Позиция);
				Возврат Строка;
			КонецЕсли;
		ИначеЕсли СТЗапрос.action="select" ИЛИ СТЗапрос.action="update" Тогда
			Позиция=Число(СТЗапрос.data);
			Строка=Данные.Получить(Позиция);
			Возврат Строка;
		КонецЕсли;
		Возврат Неопределено;
	Исключение
		Возврат Неопределено;
	КонецПопытки;
КонецФункции

Функция ПолучитьДанныеПоляВвода(Знач Данные,НомерПоля) Экспорт
	Данные=Прав(Данные,СтрДлина(Данные)-4);
	Если НомерПоля=1 Тогда
		Возврат БЗ_TSDAPI.ПолучитьПоле(Данные,"|");
	ИначеЕсли НомерПоля=2 Тогда
		Возврат БЗ_TSDAPI.TSDAPI.ПолучитьПоле(СледующееПоле(Данные,"|"),"|");
	ИначеЕсли НомерПоля=3 Тогда
		Возврат СледующееПоле(СледующееПоле(Данные,"|"),"|");
	КонецЕсли;
	Возврат "";
КонецФункции

Функция ПолучитьКартинку(Картинка) Экспорт
	Суфикс="";
	Если БЗ_TSDRU.Сессия().ТСДМодель=БЗ_TSDRU.МоделиТСД().AtolSmartDroidLite Тогда
		Суфикс="_xhdpi";
	КонецЕсли;
	КартинкаСтр="";
	Попытка
		Выполнить("КартинкаСтр=Base64Строка(Обработки.БЗ_TSDAPI_"+БЗ_TSDRU.Сессия().ПараметрыСессии.Операция+".ПолучитьМакет(Картинка+Суфикс))");
	Исключение
		Выполнить("КартинкаСтр=Base64Строка(Обработки.БЗ_TSDAPI_"+БЗ_TSDRU.Сессия().ПараметрыСессии.Операция+".ПолучитьМакет(Картинка))");
	КонецПопытки;
	Возврат КартинкаСтр;
КонецФункции

Функция ПолучитьHTMLТаблицу(Таб) Экспорт
	ИмяФайла=ПолучитьИмяВременногоФайла();
	Таб.Записать(ИмяФайла,ТипФайлаТабличногоДокумента.HTML5);
	Файл = Новый ЧтениеТекста(ИмяФайла);
	Html = Файл.Прочитать();
	Html = СтрЗаменить(Html,"padding-left: 5px;","padding: 5px;");
	Файл.Закрыть();
	УдалитьФайлы(ИмяФайла);
	Html="<meta time="""+ТекущаяУниверсальнаяДатаВМиллисекундах()+""">"+Html;
	ДВДанные=ПолучитьДвоичныеДанныеИзСтроки(Html);
	Стр=Base64Строка(ДВДанные);
	Возврат Стр;
КонецФункции

Процедура ПечатьMXLТаблицы(Таб,Принтер) Экспорт
	Соединение=СледующееПоле(СтрокаСоединенияИнформационнойБазы(),"""");
	Сервер=ПолучитьПоле(Соединение,"""");
		Соединение=СледующееПоле(Соединение,""""); Соединение=СледующееПоле(Соединение,"""");
	База=ПолучитьПоле(Соединение,"""");
	ИмяФайла=ПолучитьИмяВременногоФайла("mxl");
	Таб.Записать(ИмяФайла);
	СтрокаЗапуска=""""+КаталогПрограммы()+"1cv8.exe"" ENTERPRISE /S"""+Сервер+"/"+База+""" /C""PRINT|"+ИмяФайла+"|"+Принтер+"""";
	ЗапуститьПриложение(СтрокаЗапуска);
КонецПроцедуры

Процедура ИнициализацияПараметров(Шапка,Данные,Подвал,РядШапка,РядПодвал,Колонки,ТП) Экспорт
	Шапка=Новый Структура();
	Данные=Новый Структура();
	Подвал=Новый Структура();
	РядШапка=БЗ_TSDRU.ПараметрыРядШапка();
	РядПодвал=БЗ_TSDRU.ПараметрыРядПодвал();
	Колонки=БЗ_TSDRU.ПараметрыКолонки();
	ТП=БЗ_TSDRU.ПараметрыТекстовоеПоле();
КонецПроцедуры

Процедура ПерехватСобытий(Кнопки=Неопределено,Сканер=Неопределено) Экспорт
	Если Кнопки="" Тогда
		БЗ_TSDRU.Ответ().Удалить(БЗ_TSDRU.ПараметрыПакетОтвета().key_hook);
	Иначе
		БЗ_TSDRU.Ответ().Вставить(БЗ_TSDRU.ПараметрыПакетОтвета().key_hook,Кнопки);
	КонецЕсли;
	Если Сканер="" Тогда
		БЗ_TSDRU.Ответ().Удалить(БЗ_TSDRU.ПараметрыПакетОтвета().scan_hook);
	Иначе
		БЗ_TSDRU.Ответ().Вставить(БЗ_TSDRU.ПараметрыПакетОтвета().scan_hook,Сканер);
	КонецЕсли;	
КонецПроцедуры

Процедура УстановитьТаймер(ВремяВМиллисекундах,Событие) Экспорт
	Таймер=Новый Структура("ms,action",ВремяВМиллисекундах,Событие);
	БЗ_TSDRU.Ответ().Вставить(БЗ_TSDRU.ПараметрыПакетОтвета().timer_action,Таймер);
КонецПроцедуры

Процедура НастройкаСотрудника_Сохранить(Настройка,Данные) Экспорт
	НаборЗаписей=РегистрыСведений.БЗ_ТСД_НастройкиПользователя.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Настройка.Установить(Настройка);
	НаборЗаписей.Отбор.Сотрудник.Установить(БЗ_TSDRU.Сессия().Сотрудник);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	Запись=НаборЗаписей.Добавить();
	Запись.Настройка=Настройка;
	Запись.Сотрудник=БЗ_TSDRU.Сессия().Сотрудник;
	Запись.Данные=Новый ХранилищеЗначения(Данные);
	НаборЗаписей.Записать(Истина);
КонецПроцедуры

Функция НастройкаСотрудника_Получить(Настройка) Экспорт
	Отбор=Новый Структура();
	Отбор.Вставить("Настройка",Настройка);
	Отбор.Вставить("Сотрудник",БЗ_TSDRU.Сессия().Сотрудник);
	Настройка=РегистрыСведений.БЗ_ТСД_НастройкиПользователя.Получить(Отбор);
	Возврат Настройка.Данные.Получить();
КонецФункции

// --- Шаблоны ---
Функция РядАвторизацииПользователя() Экспорт
	ТП=БЗ_TSDRU.ПараметрыТекстовоеПоле();
	Колонки=БЗ_TSDRU.ПараметрыКолонки();
	Ряд=Новый Структура();
		ТПоле=Новый Структура();	
		ТПоле.Вставить(ТП.tx,СокрЛП(БЗ_TSDRU.Сессия().ТСДНомер));
		ТПоле.Вставить(ТП.al,"cc");
		ТПоле.Вставить(ТП.wt,"0.2");
		ТПоле.Вставить(ТП.fs,"15");
		ТПоле.Вставить(ТП.mr,"0 5 1 1");
		ТПоле.Вставить(ТП.pd,"2 2 0 0");
		ТПоле.Вставить(ТП.sw,"1");
		ТПоле.Вставить(ТП.tc,"#000000");
		ТПоле.Вставить(ТП.bc,"#FFFFFF");
		ТПоле.Вставить(ТП.sc,"#0000FF");
	Ряд.Вставить(Колонки.c1,ТПоле);
		ТПоле=Новый Структура();			
		ТПоле.Вставить(ТП.tx,"Сотрудник:");
		ТПоле.Вставить(ТП.tc,"#000000");
		ТПоле.Вставить(ТП.al,"lc");
		ТПоле.Вставить(ТП.wt,"0.5");
		ТПоле.Вставить(ТП.fs,"15");
	Ряд.Вставить(Колонки.c2,ТПоле);
		ТПоле=Новый Структура();
		ТПоле.Вставить(ТП.tx,ВРег(БЗ_TSDRU.Сессия().Сотрудник.Наименование));
		ТПоле.Вставить(ТП.al,"rc");	
		ТПоле.Вставить(ТП.tc,"#0000FF");
		ТПоле.Вставить(ТП.fs,"16");
		ТПоле.Вставить(ТП.pd,"0 2 0 0");
	Ряд.Вставить(Колонки.c3,ТПоле);	
	Возврат Ряд;
КонецФункции

Функция РядУчастокРабМестоПользователя() Экспорт
	ТП=БЗ_TSDRU.ПараметрыТекстовоеПоле();
	Колонки=БЗ_TSDRU.ПараметрыКолонки();
	Ряд=Новый Структура();
		ТПоле=Новый Структура();
		ТПоле.Вставить(ТП.tx,ВРег(НСокр(БЗ_TSDRU.Сессия().ПараметрыСессии.Участок)));
		ТПоле.Вставить(ТП.al,"lc");	
		ТПоле.Вставить(ТП.tc,"#000000");
		ТПоле.Вставить(ТП.fs,"16");
		ТПоле.Вставить(ТП.pd,"4 0 1 0");
	Ряд.Вставить(Колонки.c1,ТПоле);
		ТПоле=Новый Структура();
		ТПоле.Вставить(ТП.tx,ВРег(НСокр(БЗ_TSDRU.Сессия().ПараметрыСессии.РабочееМесто)));
		ТПоле.Вставить(ТП.al,"rc");	
		ТПоле.Вставить(ТП.tc,"#000000");
		ТПоле.Вставить(ТП.fs,"16");
		ТПоле.Вставить(ТП.pd,"0 4 1 0");		
	Ряд.Вставить(Колонки.c3,ТПоле);
	Ряд.Вставить(ТП.sw,1);
	Ряд.Вставить(ТП.sc,"#A0A0A0");
	Ряд.Вставить(ТП.st,"0 0 1 0");
	Ряд.Вставить(ТП.bc,"#FFFF88");
	Возврат Ряд;
КонецФункции

Функция ШаблонСписокДокументов(Обновление=Ложь) Экспорт
	Список=Новый Структура();
	ПараметрыСписка=БЗ_TSDRU.ПараметрыСписка();
	Если НЕ Обновление Тогда
		ТП=БЗ_TSDRU.ПараметрыТекстовоеПоле();
		Колонки=БЗ_TSDRU.ПараметрыКолонки();				
		// Параметры колонок списка
		ПараметрыКолонокСписка=Новый Структура();
		// Колонка 1
			ТПоле=Новый Структура();
			ТПоле.Вставить(ТП.al,"lc");
			ТПоле.Вставить(ТП.tc,"#000000");
			ТПоле.Вставить(ТП.fs,"17");
			ТПоле.Вставить(ТП.tf,"b");
			ТПоле.Вставить(ТП.pd,"40 0 0 0");
			ТПоле.Вставить(ТП.im,БЗ_TSDAPI.ПолучитьКартинку("doc"));
			ТПоле.Вставить(ТП.imxy,"1 -1");
			ПараметрыКолонокСписка.Вставить(Колонки.c1,ТПоле);
		// Параметры строк списка	
		ПараметрыТиповСтрок=Новый Массив();
		ПараметрыТиповСтрок.Добавить(Новый Структура("tp",0));
		ПараметрыТиповСтрок.Добавить(Новый Структура("tp,bc",1,"#E1E1E1"));
		ПараметрыТиповСтрок.Добавить(Новый Структура("tp,bc,bs",2,"#FFFF00","#BEBE00"));
		ПараметрыТиповСтрок.Добавить(Новый Структура("tp,bc,bs",3,"#BCDC9D","#9EB984"));
		ПараметрыТиповСтрок.Добавить(Новый Структура("tp,tc,sl,bc,bs,c1",4,"#FFFFFF","#FFFFFF","#FF0000","#960000",Новый Структура("tf,tc,sl","b","#FFFFFF","#FFFFFF")));
		// ---
		ПараметрыТиповСтрокСписка=БЗ_TSDRU.ПараметрыТиповСтрокСписка();
		ПараметрыСтрокСписка=Новый Структура();	
		ПараметрыСтрокСписка.Вставить(ПараметрыТиповСтрокСписка.rwtp,ПараметрыТиповСтрок);
		ПараметрыСтрокСписка.Вставить(ПараметрыТиповСтрокСписка.rt,"3hc"); // вариант шаблона
		Список.Вставить(ПараметрыСписка.cl,ПараметрыКолонокСписка);
		Список.Вставить(ПараметрыСписка.rw,ПараметрыСтрокСписка);	
	КонецЕсли;
	Возврат Список;
КонецФункции

Функция ШаблонСписокМеню(Обновление=Ложь) Экспорт
	Список=Новый Структура();
	ПараметрыСписка=БЗ_TSDRU.ПараметрыСписка();
	Если НЕ Обновление Тогда
		ТП=БЗ_TSDRU.ПараметрыТекстовоеПоле();
		Колонки=БЗ_TSDRU.ПараметрыКолонки();				
		// Параметры колонок списка
		ПараметрыКолонокСписка=Новый Структура();
		// Колонка 1
			ТПоле=Новый Структура();
			ТПоле.Вставить(ТП.al,"cc");
			ТПоле.Вставить(ТП.tc,"#0000FF");
			ТПоле.Вставить(ТП.sl,"#000000");
			ТПоле.Вставить(ТП.fs,"20");		
			ТПоле.Вставить(ТП.wt,"0.12");
			ПараметрыКолонокСписка.Вставить(Колонки.c1,ТПоле);
		// Колонка 2
			ТПоле=Новый Структура();
			ТПоле.Вставить(ТП.al,"lc");
			ТПоле.Вставить(ТП.pd,"5 5 10 10");
			ТПоле.Вставить(ТП.fs,"20");
			ТПоле.Вставить(ТП.tf,"b");
			ПараметрыКолонокСписка.Вставить(Колонки.c2,ТПоле);	
		// Параметры строк списка		
		ПараметрыТиповСтрок=Новый Массив();
		ПараметрыТиповСтрок.Добавить(Новый Структура("tp",0));
		ПараметрыТиповСтрок.Добавить(Новый Структура("tp,bc",1,"#E6E6E6"));
		// ---
		ПараметрыТиповСтрокСписка=БЗ_TSDRU.ПараметрыТиповСтрокСписка();
		ПараметрыСтрокСписка=Новый Структура();	
		ПараметрыСтрокСписка.Вставить(ПараметрыТиповСтрокСписка.rwtp,ПараметрыТиповСтрок);
		ПараметрыСтрокСписка.Вставить(ПараметрыТиповСтрокСписка.rt,"3hc"); // вариант шаблона
		Список.Вставить(ПараметрыСписка.cl,ПараметрыКолонокСписка);
		Список.Вставить(ПараметрыСписка.rw,ПараметрыСтрокСписка);
	КонецЕсли;
	Возврат Список;	
КонецФункции

Функция ШаблонСписокТовары(Обновление=Ложь) Экспорт
	Список=Новый Структура();	
	Если НЕ Обновление Тогда
		ПараметрыСписка=БЗ_TSDRU.ПараметрыСписка();
		ТП=БЗ_TSDRU.ПараметрыТекстовоеПоле();
		Колонки=БЗ_TSDRU.ПараметрыКолонки();				
		// Параметры колонок списка
		ПараметрыКолонокСписка=Новый Структура();
		// Колонка 1
			ТПоле=Новый Структура();
			ТПоле.Вставить(ТП.al,"lt");
			ТПоле.Вставить(ТП.ff,"roboto");
			ТПоле.Вставить(ТП.fs,"19");
			ТПоле.Вставить(ТП.pd,"3 1 2 2");
			ПараметрыКолонокСписка.Вставить(Колонки.c1,ТПоле);
		// Колонка 2				
			ТПоле=Новый Структура();
			ТПоле.Вставить(ТП.al,"rt");
			ТПоле.Вставить(ТП.wt,"0.42");
			ТПоле.Вставить(ТП.pd,"1 6 1 1");
			ТПоле.Вставить(ТП.ff,"roboto");
			ТПоле.Вставить(ТП.fs,"17");
			ПараметрыКолонокСписка.Вставить(Колонки.c2,ТПоле);	
		// Параметры строк списка	
		ПараметрыТиповСтрок=Новый Массив();
		ПараметрыТиповСтрок.Добавить(Новый Структура("tp,tc",0,"#000000"));
		ПараметрыТиповСтрок.Добавить(Новый Структура("tp,tc,bc,bs",1,"#000000","#BCDC9D","#9EB984"));
		ПараметрыТиповСтрок.Добавить(Новый Структура("tp,tc,bc,bs",2,"#000000","#EF8861","#B9694B"));
		ПараметрыТиповСтрок.Добавить(Новый Структура("tp,tc,sl",3,"#C80000","#C80000"));
		ПараметрыТиповСтрок.Добавить(Новый Структура("tp,tc,sl,bc,bs",4,"#C80000","#C80000","#BCDC9D","#9EB984"));
		//---
		ПараметрыТиповСтрокСписка=БЗ_TSDRU.ПараметрыТиповСтрокСписка();
		ПараметрыСтрокСписка=Новый Структура();
		ПараметрыСтрокСписка.Вставить(ПараметрыТиповСтрокСписка.rwtp,ПараметрыТиповСтрок);
		ПараметрыСтрокСписка.Вставить(ПараметрыТиповСтрокСписка.rt,"3hc"); // вариант шаблона
		Список.Вставить(ПараметрыСписка.cl,ПараметрыКолонокСписка);
		Список.Вставить(ПараметрыСписка.rw,ПараметрыСтрокСписка);
	КонецЕсли;
	Возврат Список;	
КонецФункции

Функция ШаблонРядПодсказокПоКнопкам(c1=Неопределено,c2=Неопределено,c3=Неопределено,wt1=Неопределено,wt2=Неопределено,wt3=Неопределено) Экспорт
	Колонки=БЗ_TSDRU.ПараметрыКолонки();
	ТП=БЗ_TSDRU.ПараметрыТекстовоеПоле();    
	Ряд=Новый Структура();
	Если c1<>Неопределено Тогда		
		ТПоле=Новый Структура();
		ТПоле.Вставить(ТП.tx,c1);
		ТПоле.Вставить(ТП.tc,"#303030");
		ТПоле.Вставить(ТП.al,"lc");
		ТПоле.Вставить(ТП.fs,12);
		Если ЗначениеЗаполнено(wt1) Тогда
			ТПоле.Вставить(ТП.wt,wt1);
		КонецЕсли;
		Ряд.Вставить(Колонки.c1,ТПоле);
	КонецЕсли;
	Если c2<>Неопределено Тогда
		ТПоле=Новый Структура();
		ТПоле.Вставить(ТП.tx,c2);
		ТПоле.Вставить(ТП.tc,"#303030");
		ТПоле.Вставить(ТП.al,"lc");
		ТПоле.Вставить(ТП.fs,12);
		Если ЗначениеЗаполнено(wt2) Тогда
			ТПоле.Вставить(ТП.wt,wt2);
		КонецЕсли;		
		Ряд.Вставить(Колонки.c2,ТПоле);
	КонецЕсли;
	Если c3<>Неопределено Тогда
		ТПоле=Новый Структура();
		ТПоле.Вставить(ТП.tx,c3);
		ТПоле.Вставить(ТП.tc,"#303030");
		ТПоле.Вставить(ТП.al,"rc");
		ТПоле.Вставить(ТП.fs,12);		
		Если ЗначениеЗаполнено(wt3) Тогда
			ТПоле.Вставить(ТП.wt,wt3);
		КонецЕсли;
		Ряд.Вставить(Колонки.c3,ТПоле);
	КонецЕсли;
	Возврат Ряд;
КонецФункции

Функция ШаблонРядШапкаСписка(c1=Неопределено,c2=Неопределено,c3=Неопределено,wt1=Неопределено,wt2=Неопределено,wt3=Неопределено) Экспорт
	Колонки=БЗ_TSDRU.ПараметрыКолонки();
	ТП=БЗ_TSDRU.ПараметрыТекстовоеПоле();    
	Ряд=Новый Структура();
	Если c1<>Неопределено Тогда		
		ТПоле=Новый Структура();
		ТПоле.Вставить(ТП.tx,c1);
		ТПоле.Вставить(ТП.al,"lc");
		ТПоле.Вставить(ТП.fs,"14");			
		ТПоле.Вставить(ТП.pd,"4 0 1 1");
		ТПоле.Вставить(ТП.tc,"#404040");
		ТПоле.Вставить(ТП.bc,"#F5F2DD");
		ТПоле.Вставить(ТП.sw,1);
		ТПоле.Вставить(ТП.st,"1 1 1 0");
		Если ЗначениеЗаполнено(wt1) Тогда
			ТПоле.Вставить(ТП.wt,wt1);
		КонецЕсли;
		Ряд.Вставить(Колонки.c1,ТПоле);
	КонецЕсли;
	Если c2<>Неопределено Тогда
		ТПоле=Новый Структура();
		ТПоле.Вставить(ТП.tx,c2);
		ТПоле.Вставить(ТП.al,"lc");
		ТПоле.Вставить(ТП.wt,"0.4");
		ТПоле.Вставить(ТП.fs,"14");	
		ТПоле.Вставить(ТП.pd,"0 4 1 1");
		ТПоле.Вставить(ТП.tc,"#404040");
		ТПоле.Вставить(ТП.bc,"#F5F2DD");
		ТПоле.Вставить(ТП.sw,1);
		ТПоле.Вставить(ТП.st,"0 1 1 0");

		Если ЗначениеЗаполнено(wt2) Тогда
			ТПоле.Вставить(ТП.wt,wt2);
		КонецЕсли;		
		Ряд.Вставить(Колонки.c2,ТПоле);
	КонецЕсли;
	Если c3<>Неопределено Тогда
		ТПоле=Новый Структура();
		ТПоле.Вставить(ТП.tx,c3);
		ТПоле.Вставить(ТП.al,"rc");
		ТПоле.Вставить(ТП.wt,"0.4");
		ТПоле.Вставить(ТП.fs,"14");	
		ТПоле.Вставить(ТП.pd,"0 4 1 1");
		ТПоле.Вставить(ТП.tc,"#404040");
		ТПоле.Вставить(ТП.bc,"#F5F2DD");
		ТПоле.Вставить(ТП.sw,1);
		ТПоле.Вставить(ТП.st,"0 1 1 0");		
		Если ЗначениеЗаполнено(wt3) Тогда
			ТПоле.Вставить(ТП.wt,wt3);
		КонецЕсли;
		Ряд.Вставить(Колонки.c3,ТПоле);
	КонецЕсли;
	Возврат Ряд;
КонецФункции

// ---  Дополнительные функции ---
Функция НСокр(Ссылка) Экспорт
	Если ЗначениеЗаполнено(Ссылка.НаименованиеТСД) Тогда
		Возврат Ссылка.НаименованиеТСД;
	Иначе
		Возврат Ссылка.Наименование;
	КонецЕсли;	
КонецФункции

Функция ПредставлениеТоварХарактеристика(Товар,Характеристика) Экспорт
	Попытка
		Если ЗначениеЗаполнено(Характеристика) Тогда
			Возврат СокрЛП(Товар.Наименование)+" //"+СокрЛП(Характеристика.Наименование)+"//";
		Иначе
			Возврат СокрЛП(Товар.Наименование);
		КонецЕсли;
	Исключение
		Возврат "";
	КонецПопытки;
КонецФункции

// ---- Основная функция обработки входящего запроса ----
Функция ОбработчикЗапроса(Запрос) Экспорт
	//ТВ=ТекущаяУниверсальнаяДатаВМиллисекундах();
	СТЗапрос=БЗ_TSDRU.Запрос();
	СТЗапрос.Очистить();	
	СТЗапрос.Вставить("action",Запрос.ПараметрыЗапроса.Получить("action"));
	СТЗапрос.Вставить("data",Запрос.ПараметрыЗапроса.Получить("data"));
	СТЗапрос.Вставить("session",Запрос.ПараметрыЗапроса.Получить("session"));
	Попытка
		СТЗапрос.Вставить("req_count",Число(Запрос.ПараметрыЗапроса.Получить("req_count")));
	Исключение
		СТЗапрос.Вставить("req_count",1);
	КонецПопытки;
	СТОтвет=БЗ_TSDRU.Ответ();
	СТОтвет.Очистить();
	Ответ = Новый HTTPСервисОтвет(200);
    Ответ.Заголовки.Вставить("Content-type", "application/json");
	Если НЕ ИнициализацияСессии() Тогда
		ИнициализацияПакетаОтвета(БЗ_TSDRU.ТипыФреймов().reconnect);
		СТОтвет.result=0;		
		ЗаписьJSON=Новый ЗаписьJSON();
		ЗаписьJSON.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJSON,СТОтвет);
		JSONОтвет=ЗаписьJSON.Закрыть();		
		Ответ.УстановитьТелоИзСтроки(JSONОтвет, КодировкаТекста.UTF8);		
		Возврат Ответ;		 
	КонецЕсли;
	СТСессия=БЗ_TSDRU.Сессия();
	Если СТЗапрос.req_count=СТСессия.ЗапросНомер Тогда // Повтор предыдущего запроса отдаем из кеша		
		Ответ.УстановитьТелоИзСтроки(СТСессия.ЗапросОтвет, КодировкаТекста.UTF8);
		Возврат Ответ;
	КонецЕсли;
	СТСессия.ЗапросНомер=СТЗапрос.req_count; // Обрабатываем новый запрос
	Выполнить("Обработки.БЗ_TSDAPI_"+СТСессия.ПараметрыСессии.Операция+".ОбработчикОперации()");	
	ЗаписьJSON=Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON,СТОтвет);
	JSONОтвет=ЗаписьJSON.Закрыть();	
	СТСессия.ЗапросОтвет=JSONОтвет; // Формируем JSON ответа
	СохранитьДанныеСессии(); 		// Сохраняем данные сессии
	Ответ.УстановитьТелоИзСтроки(JSONОтвет, КодировкаТекста.UTF8);	
	Возврат Ответ;
КонецФункции