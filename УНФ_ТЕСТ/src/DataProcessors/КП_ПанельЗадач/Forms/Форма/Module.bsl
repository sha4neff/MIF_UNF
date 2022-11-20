&НаКлиенте
Перем ОткрываемаяЗадача;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущийПользователь=Пользователи.ТекущийПользователь();
	ВыбранныйСотрудник=ТекущийПользователь;	
	
	ЕстьПраваНаДругиеЗадачи=(КП_ОбщееСерверПС.ЭтоРольАдминистрированиеПроцессов() ИЛИ КП_ОбщееСерверПС.ЭтоРольЧтениеВсехЗадач());
	
	Элементы.ВыбранныйСотрудник.ТолькоПросмотр=НЕ ЕстьПраваНаДругиеЗадачи;
	Элементы.ВыбранныйСотрудник.КнопкаОчистки=ЕстьПраваНаДругиеЗадачи;
	
	ФлагАвтообновление=КП_ОбщееСервер.ЗагрузитьНастройкуПользователя("КП_ПанельЗадач", "ФлагАвтообновление");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		ЭтоВебКлиент=Истина;
	#Иначе
		ЭтоВебКлиент=Ложь;
	#КонецЕсли
	
	ИнициализироватьПанель();
		
	Если ФлагАвтообновление Тогда
		ПодключитьОбработчикОжидания("Таймер_Автообновление", 60, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Таймер_Автообновление() Экспорт
	
	Если НЕ ФлагАвтообновление Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПанельНаСервере();
	
	ПодключитьОбработчикОжидания("Таймер_Автообновление", 60, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьПанель()
	
	НашаПанель.ВыравниватьГраницыЭлементовПоШкалеВремени=Ложь;
	НашаПанель.ОтображатьТекущуюДату=Ложь;
	НашаПанель.ОтображениеВремениЭлементов=ОтображениеВремениЭлементовПланировщика.НеОтображать;
	
	ШкалаВремени=НашаПанель.ШкалаВремени.Элементы[0];
	
	//Если ЭтоВебКлиент Тогда
		//исправление ошибки платформы
		ШкалаВремени.ЦветТекста=ЦветаСтиля.ЦветФонаФормы;
		ШкалаВремени.ЦветФона=ЦветаСтиля.ЦветФонаФормы;
		ШкалаВремени.Видимость=Истина;
	//Иначе
	//	ШкалаВремени.Видимость=Ложь;
	//КонецЕсли;
	
    НашаПанельИзмерения=НашаПанель.Измерения;
    НашаПанельИзмерения.Очистить();

	ТаблицаРазделовПанели.Загрузить(ПолучитьТаблицуРазделов());	
    ИзмерениеРазделы=НашаПанельИзмерения.Добавить("Разделы");	
	
	Для Каждого СтрокаТЧ Из ТаблицаРазделовПанели Цикл		
		НовыйРаздел=ИзмерениеРазделы.Элементы.Добавить(СтрокаТЧ.Представление); //добавим в Разделы
		НовыйРаздел.ЦветТекста=СтрокаТЧ.ЦветТекста;
	    НовыйРаздел.Текст=СтрокаТЧ.Заголовок;		
	КонецЦикла;	
	
	НовыйРаздел=ИзмерениеРазделы.Элементы.Добавить("Прочее");
    НовыйРаздел.Текст=" ";

	НашаПанель.ШкалаВремени.Элементы[0].Единица=ТипЕдиницыШкалыВремени.Минута;
	
	КоличествоСтрок=30;

	НачалоТекДаты=НачалоДня(ТекущаяДата());
	НашаПанель.НачалоПериодаОтображения = НачалоТекДаты;
	НашаПанель.КонецПериодаОтображения  = НачалоТекДаты+КоличествоСтрок*60;
	
	Если НЕ ЭтоВебКлиент Тогда
		Попытка
			НашаПанель.ШкалаВремени.Элементы[0].ЛинииДелений=Новый Линия(ТипЛинииГеографическойСхемы.НетЛинии);
		Исключение
			//ошибка платформы в браузере
		КонецПопытки;
	КонецЕсли;
	
	НашаПанель.ТекущиеПериодыОтображения.Очистить();
	НашаПанель.ТекущиеПериодыОтображения.Добавить(НашаПанель.НачалоПериодаОтображения, НашаПанель.КонецПериодаОтображения);
	НашаПанель.ОтображатьПеренесенныеЗаголовки = Ложь;
	
	ЗаполнитьПанельНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПанельНаСервере()
		
	НашаПанель.Элементы.Очистить();
	
	ТаблицаЗадач=ПолучитьТаблицуЗадачПанели(ВыбранныйСотрудник); //ссылка, дата начала в панели, дата окончания в панели
	СтруктураРазделов=ПолучитьСтруктуруРазделов(ТаблицаРазделовПанели);
		
	ТекДата=НачалоДня(ТекущаяДата());
	
	НачалоКолонки=ТекДата+1*1*60;
	ДлинаЗадачи=2*60; //делаем по 3 минуты (строки) высотой
	ДлинаРазрыва=0.5*60;
	МаксимумЭлементовВРазделе=9;
	
	СтруктураПоследовательногоВремениРаздела=Новый Структура;
	СтруктураМаксимальногоВремениРаздела=Новый Структура;
	СтруктураКоличестваЗадачРаздела=Новый Структура;
	
	Для Каждого СтрокаТЧ Из ТаблицаЗадач Цикл
		
		ЗадачаСсылка=СтрокаТЧ.Задача;
		ВыполнениеПроцент=СтрокаТЧ.ВыполнениеПроцент;
		Если НЕ ЗначениеЗаполнено(ВыполнениеПроцент) Тогда
			ВыполнениеПроцент=0;
		КонецЕсли;
		
		Если ЗадачаСсылка.Выполнена Тогда
			ИмяРаздела="ЗадачиВыполненные";
		ИначеЕсли ВыполнениеПроцент=0 Тогда
			ИмяРаздела="НовыеЗадачи";			
		ИначеЕсли ВыполнениеПроцент<=25 Тогда
			ИмяРаздела="Задачи25";			
		ИначеЕсли ВыполнениеПроцент<=50 Тогда
			ИмяРаздела="Задачи50";			
		ИначеЕсли ВыполнениеПроцент>=75 Тогда
			ИмяРаздела="Задачи75";			
		КонецЕсли;		
		
		РазделЗадачи=СтруктураРазделов[ИмяРаздела];
		
		Если ЗначениеЗаполнено(СтрокаТЧ.ДатаНачала) Тогда
			ДатаНачалаВПанели=СтрокаТЧ.ДатаНачала;
			ДатаНачалаВПанели=ТекДата+(ДатаНачалаВПанели-НачалоДня(ДатаНачалаВПанели));
		Иначе		
			//расчитаем время для размещения в панели
			Если СтруктураПоследовательногоВремениРаздела.Свойство(ИмяРаздела) Тогда
				ДатаНачалаВПанели=СтруктураПоследовательногоВремениРаздела[ИмяРаздела]+ДлинаРазрыва;
			Иначе
				ДатаНачалаВПанели=НачалоКолонки;
				СтруктураПоследовательногоВремениРаздела.Вставить(ИмяРаздела, "");
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТЧ.ДатаОкончания) Тогда
			ДатаОкончанияВПанели=СтрокаТЧ.ДатаОкончания;
			ДатаОкончанияВПанели=ТекДата+(ДатаОкончанияВПанели-НачалоДня(ДатаОкончанияВПанели));
		Иначе
			ДатаОкончанияВПанели=ДатаНачалаВПанели+ДлинаЗадачи;
			СтруктураПоследовательногоВремениРаздела[ИмяРаздела]=ДатаОкончанияВПанели;
		КонецЕсли;
		
		Если СтруктураМаксимальногоВремениРаздела.Свойство(ИмяРаздела) Тогда
			Если СтруктураМаксимальногоВремениРаздела[ИмяРаздела]<ДатаОкончанияВПанели Тогда
				СтруктураМаксимальногоВремениРаздела[ИмяРаздела]=ДатаОкончанияВПанели;
			КонецЕсли;
		Иначе
			СтруктураМаксимальногоВремениРаздела.Вставить(ИмяРаздела, ДатаОкончанияВПанели);
		КонецЕсли;

		//начнем вывод
		СоответствиеЗначений = Новый Соответствие;		
		СоответствиеЗначений.Вставить("Разделы", РазделЗадачи);
		
		Если СтруктураКоличестваЗадачРаздела.Свойство(ИмяРаздела) Тогда
			КоличествоЭлементовРаздела=СтруктураКоличестваЗадачРаздела[ИмяРаздела];
		Иначе
			КоличествоЭлементовРаздела=0;
			СтруктураКоличестваЗадачРаздела.Вставить(ИмяРаздела, КоличествоЭлементовРаздела);			
		КонецЕсли;
		
		КоличествоЭлементовРаздела=КоличествоЭлементовРаздела+1;
		СтруктураКоличестваЗадачРаздела[ИмяРаздела]=КоличествоЭлементовРаздела;
		
		Если КоличествоЭлементовРаздела>(МаксимумЭлементовВРазделе-1) Тогда
			//вставим специальный элемент
			МаксимальноеВремяРаздела=СтруктураМаксимальногоВремениРаздела[ИмяРаздела];
			НовыйЭлемент=НашаПанель.Элементы.Добавить(МаксимальноеВремяРаздела+ДлинаРазрыва, МаксимальноеВремяРаздела+ДлинаРазрыва+ДлинаЗадачи/2);
			НовыйЭлемент.ЗначенияИзмерений=Новый ФиксированноеСоответствие(СоответствиеЗначений);
			НовыйЭлемент.Текст="Все задачи";
			НовыйЭлемент.Значение="ОткрытьНавигаторЗадач";
			НовыйЭлемент.ЦветФона=WebЦвета.Белый;
			НовыйЭлемент.ЦветРамки=WebЦвета.Белый;
			НовыйЭлемент.ЦветТекста=WebЦвета.Синий;
			НовыйЭлемент.Шрифт=Новый Шрифт(,,,,Истина);
			Прервать;
		КонецЕсли;
		
		НовыйЭлемент=НашаПанель.Элементы.Добавить(ДатаНачалаВПанели, ДатаОкончанияВПанели);
		НовыйЭлемент.ЗначенияИзмерений=Новый ФиксированноеСоответствие(СоответствиеЗначений);
		НовыйЭлемент.Текст=ЗадачаСсылка.Наименование;
		НовыйЭлемент.Подсказка=ПолучитьТекстЗадачи(ЗадачаСсылка);
		НовыйЭлемент.Значение=ЗадачаСсылка;
		
		Если ЗначениеЗаполнено(СтрокаТЧ.ЦветТекста) Тогда
			НовыйЭлемент.ЦветТекста=КП_ОформлениеСтрокСерверПС.ПолучитьЦветИзЦветаОбъекта(СтрокаТЧ.ЦветТекста);
		КонецЕсли;
		
		Если ЗадачаСсылка.Выполнена Тогда
			НовыйЭлемент.ЦветФона=ЦветаСтиля.ЦветФонаФормы;
			НовыйЭлемент.ЦветРамки=WebЦвета.ТемноСерый;
		Иначе			
			Если ЗначениеЗаполнено(СтрокаТЧ.ЦветФона) Тогда
				НовыйЭлемент.ЦветФона=КП_ОформлениеСтрокСерверПС.ПолучитьЦветИзЦветаОбъекта(СтрокаТЧ.ЦветФона);
			КонецЕсли;
		КонецЕсли;
		
		НовыйЭлемент.Шрифт=Новый Шрифт(,,СтрокаТЧ.ШрифтЖирный, СтрокаТЧ.ШрифтНаклонный);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстЗадачи(ЗадачаСсылка)
	
	Если КП_ОбщееСерверПС.ЭтоЗадачаКонтроля(ЗадачаСсылка) Тогда
		ТекстЗадачи="Контроль "+СокрЛП(ЗадачаСсылка.ТочкаКБП.ДействиеКонтрольТочки);
		Возврат ТекстЗадачи;
	КонецЕсли;
	
	ФорматированныйДок=ЗадачаСсылка.ХранилищеТекстаЗадания.Получить();
	
	Если ТипЗнч(ФорматированныйДок)<>Тип("ФорматированныйДокумент") Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗадачи=ФорматированныйДок.ПолучитьТекст();
	
	Если СтрДлина(ТекстЗадачи)>100 Тогда
		ТекстЗадачи=Лев(ТекстЗадачи, 100)+"...";
	КонецЕсли;
	
	Возврат ТекстЗадачи;
	
КонецФункции

Функция ПолучитьТаблицуЗадачПанели(ПользовательСсылка=Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос=Новый Запрос;
	ТекстЗапроса="ВЫБРАТЬ
	             |	КП_Задача.Ссылка КАК Задача,
				 |	ОбъектыПанели.ДатаНачала КАК ДатаНачала,
				 |	ОбъектыПанели.ДатаОкончания КАК ДатаОкончания,				 
				 |";
	
	ТекстЗапроса=ТекстЗапроса+ "
			     |	ЦветаОбъектов.ЦветТекста КАК ЦветТекста,
	             |	ЦветаОбъектов.ЦветФона КАК ЦветФона,
	             |	ЦветаОбъектов.ШрифтНаклонный КАК ШрифтНаклонный,
	             |	ЦветаОбъектов.ШрифтЖирный КАК ШрифтЖирный,";
	
	ТекстЗапроса=ТекстЗапроса+"
				 |	КП_ПараметрыЗадачПроцентСрезПоследних.ЗначениеПараметра КАК ВыполнениеПроцент	
	             |ИЗ
	             |	Задача.КП_Задача КАК КП_Задача
				   |";
	
	ТекстЗапроса=ТекстЗапроса+"
	             |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	             |			КП_ЦветаОбъектов.ЦветТекста КАК ЦветТекста,
	             |			КП_ЦветаОбъектов.ЦветФона КАК ЦветФона,
	             |			КП_ЦветаОбъектов.ШрифтНаклонный КАК ШрифтНаклонный,
	             |			КП_ЦветаОбъектов.ШрифтЖирный КАК ШрифтЖирный,
	             |			КП_ЦветаОбъектов.ОбъектНастройки КАК ОбъектНастройки
	             |		ИЗ
	             |			РегистрСведений.КП_ЦветаОбъектов КАК КП_ЦветаОбъектов
	             |		ГДЕ
	             |			КП_ЦветаОбъектов.Пользователь = &ПользовательПанели) КАК ЦветаОбъектов
	             |		ПО КП_Задача.Ссылка = ЦветаОбъектов.ОбъектНастройки";
		
	ТекстЗапроса=ТекстЗапроса+"
				 |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
				 |			КП_ОбъектыПанели.ДатаНачала КАК ДатаНачала,
				 |			КП_ОбъектыПанели.ДатаОкончания КАК ДатаОкончания,
				 |			КП_ОбъектыПанели.ОбъектПанели КАК ОбъектПанели
				 |		ИЗ
				 |			РегистрСведений.КП_ОбъектыПанели КАК КП_ОбъектыПанели
				 |		ГДЕ				 
				 |			КП_ОбъектыПанели.ИмяПанели = ""ПанельЗадач""
				 |		И КП_ОбъектыПанели.Пользователь = &ПользовательПанели
				 |";
	
	ТекстЗапроса=ТекстЗапроса+"
				 |		) КАК ОбъектыПанели
				 |		ПО КП_Задача.Ссылка = ОбъектыПанели.ОбъектПанели
				 |";
	
	
	ТекстЗапроса=ТекстЗапроса+"
				|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КП_ПараметрыЗадач.СрезПоследних(&ТекущаяДата, ПараметрЗадачи = &ПараметрВыполнениеПроцент) КАК КП_ПараметрыЗадачПроцентСрезПоследних
				|	ПО КП_Задача.Ссылка = КП_ПараметрыЗадачПроцентСрезПоследних.Задача";
	
	ТекстЗапроса=ТекстЗапроса+"
	             |ГДЕ
				 |	КП_Задача.ТочкаМаршрута <> &СлужебнаяТочка
	             |	И КП_Задача.ПометкаУдаления = ЛОЖЬ
				 |	И (НЕ КП_Задача.Выполнена ИЛИ КП_Задача.ДатаВыполненияФакт >= НАЧАЛОПЕРИОДА(&ТекущаяДата, ДЕНЬ))
				 |";
		
	Если ЗначениеЗаполнено(ПользовательСсылка) Тогда
		ТекстЗапроса=ТекстЗапроса+" И КП_Задача.Исполнитель = &Исполнитель";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПользовательСсылка) Тогда
		Запрос.УстановитьПараметр("Исполнитель", ПользовательСсылка);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ПользовательПанели", ТекущийПользователь);
	
	ТекстЗапроса=ТекстЗапроса+"
				 |УПОРЯДОЧИТЬ ПО
				 |	Дата Возр";
	
	ТекДата=ТекущаяДата();
	Запрос.УстановитьПараметр("СлужебнаяТочка", БизнесПроцессы.КП_БизнесПроцесс.ТочкиМаршрута.ВыполнениеКорпоративногоПроцесса);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекДата);
	Запрос.УстановитьПараметр("ПараметрВыполнениеПроцент", ПланыВидовХарактеристик.КП_ПараметрыЗадач.ВыполнениеПроцент);
	Запрос.Текст=ТекстЗапроса;
	
	Таблица=Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.Прямой);
	
	Возврат Таблица;
	
КонецФункции

&НаСервере
Функция ПолучитьСтруктуруРазделов(Таблица)
	
	СтруктураРазделов=Новый Структура;
	Для Каждого СтрокаТЧ Из Таблица Цикл
		СтруктураРазделов.Вставить(СтрокаТЧ.Имя, СтрокаТЧ.Представление);
	КонецЦикла;
	
	Возврат СтруктураРазделов;
	
КонецФункции

&НаСервере
Функция ПолучитьТаблицуРазделов()
	
	Таблица=Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("Заголовок", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("ЦветТекста", Новый ОписаниеТипов("Цвет"));
	Таблица.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	
	НоваяСтрока=Таблица.Добавить();
	НоваяСтрока.Имя="НовыеЗадачи";
	НоваяСтрока.Заголовок="Новые задачи";
	НоваяСтрока.Представление="Новые задачи";
	НоваяСтрока.ЦветТекста=WebЦвета.ТемноКрасный;
	
	НоваяСтрока=Таблица.Добавить();
	НоваяСтрока.Имя="Задачи25";
	НоваяСтрока.Представление="Задачи в работе (выполнение до 25% включительно)";
	НоваяСтрока.ЦветТекста=WebЦвета.Черный;	
	
	Если ЗначениеЗаполнено(ВыбранныйСотрудник) И ЭтоЖенскийПол(ВыбранныйСотрудник) Тогда
		НоваяСтрока.Заголовок="Только начала";
	Иначе
		НоваяСтрока.Заголовок="Только начал";
	КонецЕсли;
	
	НоваяСтрока=Таблица.Добавить();
	НоваяСтрока.Имя="Задачи50";
	НоваяСтрока.Представление="Задачи в работе (выполнение больше 25% и меньше 75%)";
	НоваяСтрока.ЦветТекста=WebЦвета.Черный;
    НоваяСтрока.Заголовок="Активно работаю";
	
	НоваяСтрока=Таблица.Добавить();
	НоваяСтрока.Имя="Задачи75";
	НоваяСтрока.Представление="Задачи в работе (выполнение 75% и выше)";
	НоваяСтрока.ЦветТекста=WebЦвета.Черный;
    НоваяСтрока.Заголовок="Почти готово";
	                               	
	НоваяСтрока=Таблица.Добавить();
	НоваяСтрока.Имя="ЗадачиВыполненные";
	НоваяСтрока.Представление="Выполненные сегодня задачи";
	НоваяСтрока.ЦветТекста=WebЦвета.Зеленый;	
    НоваяСтрока.Заголовок="Выполнено";
	
	Возврат Таблица;
	
КонецФункции

&НаКлиенте
Процедура НашаПанельПередНачаломБыстрогоРедактирования(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НашаПанельВыбор(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
	
	Если Элемент.ВыделенныеЭлементы.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	ВыбраннаяЗадача=Элемент.ВыделенныеЭлементы[0].Значение;
	
	ОткрываемаяЗадача=ВыбраннаяЗадача;
	Состояние("Открытие задачи...", 33);
	
	ПараметрыФормы = Новый Структура("Ключ", ВыбраннаяЗадача);
	ОткрытьФорму("Задача.КП_Задача.ФормаОбъекта", ПараметрыФормы);
			
КонецПроцедуры

&НаКлиенте
Процедура НашаПанельПриСменеТекущегоПериодаОтображения(Элемент, ТекущиеПериодыОтображения, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "КП_Задача" Тогда
		Если Параметр="Записана" Тогда
			ЗаполнитьПанельНаСервере();
		ИначеЕсли Параметр="Выполнена" Тогда
			ЗаполнитьПанельНаСервере();			
		ИначеЕсли Параметр="Открыта" И Источник=ОткрываемаяЗадача Тогда
			Состояние("Открытие задачи...", 100);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПанель(Команда)
	ЗаполнитьПанельНаСервере();
	Состояние("Панель обновлена");
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныйСотрудникПриИзменении(Элемент)
	ИнициализироватьПанель();
КонецПроцедуры

&НаКлиенте
Процедура НашаПанельПередНачаломРедактирования(Элемент, НовыйЭлемент, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
КонецПроцедуры

&НаКлиенте
Процедура НашаПанельПриОкончанииРедактирования(Элемент, НовыйЭлемент, ОтменаРедактирования)
	
	Если Элемент.ВыделенныеЭлементы.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияИзмерений=Элемент.ВыделенныеЭлементы[0].ЗначенияИзмерений;
	ПредставлениеРаздела=ЗначенияИзмерений.Получить("Разделы");
	Если ПредставлениеРаздела="Прочее" Тогда
		ОтменаРедактирования=Истина;
		Возврат;
	КонецЕсли;
	
	ВыбранныйЭлемент=Элемент.ВыделенныеЭлементы[0];
	ЗадачаСсылка=ВыбранныйЭлемент.Значение;
	
	//запишем положение в панели
	ДатаНачала=Элемент.ВыделенныеЭлементы[0].Начало;
	ДатаОкончания=Элемент.ВыделенныеЭлементы[0].Конец;	
	ЗаписатьПоложениеЗадачи(ЗадачаСсылка, ДатаНачала, ДатаОкончания);
	
	ИсполнительЗадачи=КП_ОбщееСервер.ПолучитьЗначениеРеквизитаОбъекта(ЗадачаСсылка, "Исполнитель");
	Если ИсполнительЗадачи<>ТекущийПользователь Тогда
		Состояние("Задача принадлежит другому пользователю. Изменение не возможно");
		ЗаполнитьПанельНаСервере();
		Возврат;
	КонецЕсли;
	
	ИмяРаздела=ПолучитьИмяРазделаПоПредставлению(ПредставлениеРаздела);
	
	Если ПустаяСтрока(ИмяРаздела) Тогда
		ВызватьИсключение "Не известное имя раздела """+ПредставлениеРаздела+"""";
	КонецЕсли;
	
	Если ИмяРаздела="НовыеЗадачи" Тогда
		ВыполнениеПроцент=0;
	ИначеЕсли ИмяРаздела="Задачи25" Тогда
		ВыполнениеПроцент=25;
	ИначеЕсли ИмяРаздела="Задачи50" Тогда
		ВыполнениеПроцент=50;
	ИначеЕсли ИмяРаздела="Задачи75" Тогда
		ВыполнениеПроцент=75;
	ИначеЕсли ИмяРаздела="ЗадачиВыполненные" Тогда
		ВыполнениеПроцент=100;		
	КонецЕсли;
		
	Если ВыполнениеПроцент<>100 И КП_ОбщееСервер.ПолучитьЗначениеРеквизитаОбъекта(ЗадачаСсылка, "Выполнена") Тогда
		Состояние("Задача уже выполнена");
		ОтменаРедактирования=Истина;
		Возврат;
	КонецЕсли;
	
	Если ВыполнениеПроцент=100  Тогда
		ЭтоЗадачаКонтроля=КП_ОбщееСерверПС.ЭтоЗадачаКонтроля(ЗадачаСсылка);
		Если ЭтоЗадачаКонтроля Тогда
			ТекстВопроса=НСтр("ru='Задача контроля будет открыта';");
		Иначе
			ТекстВопроса=НСтр("ru='Задача будет открыта для подтверждения выполнения';");
		КонецЕсли;
		
		ПоказатьВопрос(Новый ОписаниеОповещения("Оповещение_ОтветНаВопросВыполненияЗадачи", ЭтаФорма, Новый Структура("Задача, ЭтоЗадачаКонтроля", ЗадачаСсылка, ЭтоЗадачаКонтроля)),
			ТекстВопроса, КП_ОбщееКлиент.КнопкиОКОтмена("ОК, открыть"),,,КП_ОбщееКлиент.ЗаголовокДиалога());
		Возврат;
		
	КонецЕсли;
			
	Если СохранитьПараметрыЗадачи(ЗадачаСсылка, ВыполнениеПроцент) И ВыполнениеПроцент=100 Тогда
		ВыбранныйЭлемент.ЦветТекста=WebЦвета.ТемноСерый;
		ВыбранныйЭлемент.ЦветФона=WebЦвета.Белый;
		ВыбранныйЭлемент.ЦветРамки=WebЦвета.СветлоСерый;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Оповещение_ОтветНаВопросВыполненияЗадачи(Результат, ДопПараметры) Экспорт
	
	Если Результат=КодВозвратаДиалога.Отмена Тогда
		ЗаполнитьПанельНаСервере();
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы=Новый Структура("Ключ", ДопПараметры.Задача);
	
	Если ДопПараметры.ЭтоЗадачаКонтроля Тогда
		ОткрытьФорму("Задача.КП_Задача.Форма.ФормаКонтроля", ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		ОткрытьФорму("Задача.КП_Задача.Форма.ФормаИсполнения", ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СохранитьПараметрыЗадачи(ЗадачаСсылка, ВыполнениеПроцент)
	
	ДатаНачалаВыполнения=Неопределено;
	СтруктураПараметровЗадачи=КП_ЗадачиПроцессов.ПолучитьСтруктуруПараметровЗадачи(ЗадачаСсылка);
	СтруктураПараметровЗадачи.Свойство("ДатаНачалаВыполнения", ДатаНачалаВыполнения);
	
	Если НЕ ЗначениеЗаполнено(ДатаНачалаВыполнения) Тогда
		ДатаНачалаВыполнения=ТекущаяДата();
	КонецЕсли;
	
	Если НЕ СтруктураПараметровЗадачи.Свойство("ВыполнениеПроцент") Тогда
		СтруктураПараметровЗадачи.Вставить("ВыполнениеПроцент", ВыполнениеПроцент);
	Иначе	
		СтруктураПараметровЗадачи.ВыполнениеПроцент=ВыполнениеПроцент;
	КонецЕсли;
		
	Если ВыполнениеПроцент=100 И НЕ ЗадачаСсылка.Выполнена Тогда
		ЗадачаОбъект=ЗадачаСсылка.ПолучитьОбъект();
		Попытка
			ЗадачаОбъект.ВыполнитьЗадачу();
			ЗадачаОбъект.Записать();
		Исключение
			КП_ОбщееСервер.ЗаписатьОшибку(ОписаниеОшибки());
			Возврат Ложь;
		КонецПопытки;
	КонецЕсли;
	
	КП_ЗадачиПроцессов.СохранитьСтруктуруПараметровЗадачи(СтруктураПараметровЗадачи, ЗадачаСсылка);
	
	Если ЗадачаСсылка.Выполнена Тогда
		КП_ЗадачиПроцессов.УстановитьСостояниеЗадачи(ЗадачаСсылка, Перечисления.КП_СостояниеЗадач.Выполнена);
	Иначе
		КП_ЗадачиПроцессов.УстановитьСостояниеЗадачи(ЗадачаСсылка, Перечисления.КП_СостояниеЗадач.Выполняется);
	КонецЕсли;
	
	Возврат Истина;

КонецФункции

&НаСервере
Функция ПолучитьИмяРазделаПоПредставлению(ПредставлениеРаздела)
	МассивСтрок=ТаблицаРазделовПанели.НайтиСтроки(Новый Структура("Представление", ПредставлениеРаздела));
	Если МассивСтрок.Количество()=0 Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат МассивСтрок[0].Имя;
	
КонецФункции

&НаКлиенте
Процедура НашаПанельПриАктивизации(Элемент)
	
	СтандартнаяОбработка=Ложь;
	
	Если Элемент.ВыделенныеЭлементы.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранныйЭлемент=Элемент.ВыделенныеЭлементы[0];
	ЗначениеЭлемента=ВыбранныйЭлемент.Значение;
	
	Если ТипЗнч(ЗначениеЭлемента)<>Тип("Строка") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЭлемента="ОткрытьНавигаторЗадач" Тогда
		ОткрытьФорму("Обработка.КП_НавигаторЗадач.Форма",,,,,,,РежимОткрытияОкнаФормы.Независимый);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НашаПанельПередСозданием(Элемент, Начало, Конец, Значения, Текст, СтандартнаяОбработка)

	СтандартнаяОбработка=Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура Оповещение_ВидПроцессаВыбран(Результат, ДопПараметры) Экспорт
	
	Если Результат=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПроцессСсылка=КП_Процессы.СоздатьБизнесПроцесс(Результат, ТекущийПользователь);
	Если ОбновитьПроцессНаСервере(ПроцессСсылка) Тогда
		ПараметрыФормы=Новый Структура("Ключ", ПроцессСсылка);
		ОткрытьФорму("БизнесПроцесс.КП_БизнесПроцесс.ФормаОбъекта", ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

Функция ОбновитьПроцессНаСервере(ПроцессСсылка)
	
	ПроцессОбъект=ПроцессСсылка.ПолучитьОбъект();
	ПроцессОбъект.Комментарий="Создано из панели";
	
	Попытка
		ПроцессОбъект.Записать();
	Исключение
		ТекстОшибки=ОписаниеОшибки();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ЭтоЖенскийПол(Пользователь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос=Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                     |	СотрудникиПользователя.Сотрудник.Физлицо.Пол КАК Пол
	                     |ИЗ
	                     |	РегистрСведений.СотрудникиПользователя КАК СотрудникиПользователя
	                     |ГДЕ
	                     |	СотрудникиПользователя.Сотрудник.ПометкаУдаления = ЛОЖЬ
	                     |	И СотрудникиПользователя.Пользователь = &Пользователь");
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Если Выборка.Следующий() Тогда
		Если Выборка.Пол=Перечисления.ПолФизическогоЛица.Женский Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура ЗаписатьПоложениеЗадачи(СсылкаНаЗадачу, ДатаНачала, ДатаОкончания)
	ИмяПанели="ПанельЗадач";
	КП_ЗадачиПроцессов.ЗаписатьПоложениеВПанели(СсылкаНаЗадачу, ТекущийПользователь, ДатаНачала, ДатаОкончания, ИмяПанели);
КонецПроцедуры

&НаКлиенте
Процедура ФлагАвтообновлениеПриИзменении(Элемент)
	Если ФлагАвтообновление Тогда
		ПодключитьОбработчикОжидания("Таймер_Автообновление", 60, Истина);
	Иначе
		ОтключитьОбработчикОжидания("Таймер_Автообновление");
	КонецЕсли;
	
	КП_ОбщееСервер.СохранитьНастройкуПользователя("КП_ПанельЗадач", "ФлагАвтообновление", ФлагАвтообновление);
	
КонецПроцедуры

ОткрываемаяЗадача=Неопределено;
